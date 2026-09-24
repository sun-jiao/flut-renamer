import Darwin
import UIKit
import Flutter
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    private var pickerRegistrar: FlutterPluginRegistrar?
    private var selectedDirectories: [String: URL] = [:]
    private var activeDirectories: [String: URL] = [:]
    private var pickerDirectory: URL?
    private weak var activePicker: UIDocumentPickerViewController?
    private let fileQueue = DispatchQueue(label: "net.sunjiao.renamer.files")

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "RenamerFilePicker") {
            pickerRegistrar = registrar
            let filePickerChannel = FlutterMethodChannel(
                name: "net.sunjiao.renamer/picker",
                binaryMessenger: registrar.messenger()
            )
            filePickerChannel.setMethodCallHandler {
                [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                guard let self = self else {
                    result(FlutterError(
                        code: "APP_DELEGATE_UNAVAILABLE",
                        message: "The iOS application delegate is unavailable.",
                        details: nil
                    ))
                    return
                }

                switch call.method {
                case "dirAccess":
                    self.dirAccess(result: result)
                case "fileAccess":
                    guard
                        let args = call.arguments as? [String: Any],
                        let startPath = args["startPath"] as? String
                    else {
                        result(self.invalidArgumentsError(for: call.method))
                        return
                    }
                    self.fileAccess(startPath: startPath, result: result)
                case "changeScopedAccess":
                    guard
                        let args = call.arguments as? [String: Any],
                        let targetPath = args["targetPath"] as? String,
                        let startOrEnd = args["startOrEnd"] as? Bool
                    else {
                        result(self.invalidArgumentsError(for: call.method))
                        return
                    }
                    self.changeScopedAccess(
                        targetPath: targetPath,
                        startOrEnd: startOrEnd,
                        result: result
                    )
                case "retainScopedAccess":
                    guard let args = call.arguments as? [String: Any],
                          let paths = args["paths"] as? [String] else {
                        result(self.invalidArgumentsError(for: call.method))
                        return
                    }
                    for (path, url) in Array(self.activeDirectories) {
                        if !paths.contains(where: { self.contains(url, path: $0) }) {
                            url.stopAccessingSecurityScopedResource()
                            self.activeDirectories.removeValue(forKey: path)
                        }
                    }
                    self.selectedDirectories = self.activeDirectories
                    result(nil)
                case "coordinatedRename":
                    guard let args = call.arguments as? [String: Any],
                          let source = args["source"] as? String,
                          let destination = args["destination"] as? String else {
                        result(self.invalidArgumentsError(for: call.method))
                        return
                    }
                    self.coordinatedRename(source: source, destination: destination, result: result)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }

    private var currentFR: FlutterResult?
    private var finishingPicker = false

    private func contains(_ directory: URL, path: String) -> Bool {
        let root = directory.resolvingSymlinksInPath().standardizedFileURL.path
        let candidate = URL(fileURLWithPath: path).resolvingSymlinksInPath().standardizedFileURL.path
        return candidate == root || candidate.hasPrefix(root + "/")
    }

    private func dirAccess(result: @escaping FlutterResult) {
        presentPicker(directory: nil, result: result)
    }

    private func fileAccess(startPath: String, result: @escaping FlutterResult) {
        guard let directory = activeDirectories[startPath] ?? selectedDirectories[startPath],
              activeDirectories[startPath] != nil || contains(URL(fileURLWithPath: NSHomeDirectory()), path: startPath) else {
            result(FlutterError(code: "ACCESS_DENIED",
                                message: "Select and authorize a folder first.", details: nil))
            return
        }
        presentPicker(directory: directory, result: result)
    }

    private func presentPicker(directory: URL?, result: @escaping FlutterResult) {
        guard currentFR == nil else {
            result(FlutterError(code: "PICKER_BUSY", message: "A picker is already open.", details: nil))
            return
        }
        guard let presenter = pickerRegistrar?.viewController,
              presenter.viewIfLoaded?.window?.windowScene?.activationState == .foregroundActive,
              presenter.presentedViewController == nil else {
            result(noPresentationContextError)
            return
        }
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: directory == nil ? [.folder] : [.item], asCopy: false)
        picker.delegate = self
        picker.allowsMultipleSelection = directory != nil
        picker.directoryURL = directory
        pickerDirectory = directory
        currentFR = result
        activePicker = picker
        presenter.present(picker, animated: true)
        picker.presentationController?.delegate = self
    }

    private func changeScopedAccess(targetPath: String, startOrEnd: Bool, result: FlutterResult) {
        if startOrEnd {
            if activeDirectories[targetPath] != nil {
                result(true)
                return
            }
            // Keep the original picker URL, including its security scope.
            guard let url = selectedDirectories[targetPath],
                  url.startAccessingSecurityScopedResource() else {
                // App-private files need no security-scoped grant.
                result(contains(URL(fileURLWithPath: NSHomeDirectory()), path: targetPath))
                return
            }
            activeDirectories[targetPath] = url
        } else if let url = activeDirectories.removeValue(forKey: targetPath) {
            url.stopAccessingSecurityScopedResource()
            selectedDirectories.removeValue(forKey: targetPath)
        }
        result(true)
    }

    private func coordinatedRename(source: String, destination: String, result: @escaping FlutterResult) {
        let oldURL = URL(fileURLWithPath: source)
        let newURL = URL(fileURLWithPath: destination)
        // Keep a separate grant while work is queued, even if the UI removes the row.
        let scope = activeDirectories.values.first {
            contains($0, path: source) && contains($0, path: destination)
        }
        let operationGrant = scope?.startAccessingSecurityScopedResource() ?? false
        let home = URL(fileURLWithPath: NSHomeDirectory())
        guard operationGrant || (contains(home, path: source) && contains(home, path: destination)) else {
            result(FlutterError(code: "ACCESS_DENIED", message: "Folder access is no longer available. Select the folder again.", details: nil))
            return
        }
        fileQueue.async {
            defer { if operationGrant { scope?.stopAccessingSecurityScopedResource() } }
            let coordinator = NSFileCoordinator()
            var coordinationError: NSError?
            var operationError: NSError?
            var renamedPath: String?
            coordinator.coordinate(writingItemAt: oldURL, options: .forMoving,
                                   writingItemAt: newURL, options: [],
                                   error: &coordinationError) { sourceURL, destinationURL in
                coordinator.item(at: sourceURL, willMoveTo: destinationURL)
                var status = renamex_np(sourceURL.path, destinationURL.path, UInt32(RENAME_EXCL))
                var errorCode = errno
                // Preserve case-only renames on case-insensitive volumes.
                if status != 0 && errorCode == EEXIST {
                    var sourceStat = stat()
                    var destinationStat = stat()
                    if lstat(sourceURL.path, &sourceStat) == 0 &&
                        lstat(destinationURL.path, &destinationStat) == 0 &&
                        sourceStat.st_dev == destinationStat.st_dev &&
                        sourceStat.st_ino == destinationStat.st_ino {
                        // Qualify the POSIX function to avoid UIResponder.rename(_:).
                        status = Darwin.rename(sourceURL.path, destinationURL.path)
                        errorCode = errno
                    }
                }
                if status == 0 {
                    coordinator.item(at: sourceURL, didMoveTo: destinationURL)
                    renamedPath = destinationURL.path
                } else {
                    operationError = NSError(domain: NSPOSIXErrorDomain, code: Int(errorCode))
                }
            }
            let failure = coordinationError ?? operationError
            DispatchQueue.main.async {
                if let failure = failure {
                    result(FlutterError(code: "RENAME_FAILED", message: failure.localizedDescription,
                                        details: ["domain": failure.domain, "code": failure.code]))
                } else if let path = renamedPath {
                    result(path)
                } else {
                    result(FlutterError(code: "RENAME_FAILED", message: "No coordinated rename occurred.", details: nil))
                }
            }
        }
    }

    private func invalidArgumentsError(for method: String) -> FlutterError {
        FlutterError(
            code: "INVALID_ARGUMENTS",
            message: "Invalid arguments for \(method).",
            details: nil
        )
    }

    private var noPresentationContextError: FlutterError {
        FlutterError(
            code: "NO_PRESENTATION_CONTEXT",
            message: "No iOS view controller is available to present the document picker.",
            details: nil
        )
    }
}

extension AppDelegate: UIDocumentPickerDelegate, UIAdaptivePresentationControllerDelegate {
    private func finishPicker(_ controller: UIDocumentPickerViewController, value: Any?) {
        guard controller === activePicker, !finishingPicker, let result = currentFR else { return }
        finishingPicker = true
        // Finish dismissal before Dart can immediately request a second picker.
        controller.dismiss(animated: true) {
            self.finishingPicker = false
            self.currentFR = nil
            self.activePicker = nil
            self.pickerDirectory = nil
            result(value)
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard controller === activePicker else { return }
        if let directory = pickerDirectory {
            // directoryURL is a starting location, not a navigation restriction.
            // Renaming requires the containing folder's grant, not just the file's.
            guard urls.allSatisfy({ contains(directory, path: $0.path) && $0.path != directory.path }) else {
                finishPicker(controller, value: FlutterError(code: "OUTSIDE_AUTHORIZED_DIRECTORY",
                                    message: "Select files inside the authorized folder, or select their folder first.",
                                    details: nil))
                return
            }
        } else {
            for url in urls { selectedDirectories[url.path] = url }
        }
        finishPicker(controller, value: urls.map { $0.path })
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        finishPicker(controller, value: nil)
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard !finishingPicker, presentationController.presentedViewController === activePicker,
              let result = currentFR else { return }
        currentFR = nil
        activePicker = nil
        pickerDirectory = nil
        result(nil)
    }
}

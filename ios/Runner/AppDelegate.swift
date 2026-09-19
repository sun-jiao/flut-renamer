import UIKit
import Flutter
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if let registrar = registrar(forPlugin: "RenamerFilePicker") {
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
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    var currentFR: FlutterResult?

    private func dirAccess(result: @escaping FlutterResult) {
        let folderPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        folderPicker.delegate = self
        guard let presenter = presentationViewController else {
            result(noPresentationContextError)
            return
        }
        self.currentFR = result
        presenter.present(folderPicker, animated: true, completion: nil)
    }

    private func fileAccess(startPath: String, result: @escaping FlutterResult) {
        let startUrl = URL(fileURLWithPath: startPath)
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.directoryURL = startUrl
        guard let presenter = presentationViewController else {
            result(noPresentationContextError)
            return
        }
        self.currentFR = result
        presenter.present(documentPicker, animated: true, completion: nil)
    }

    private func changeScopedAccess(targetPath: String, startOrEnd: Bool, result: FlutterResult) {
        let targetUrl = URL(fileURLWithPath: targetPath)

        if startOrEnd {
            _ = targetUrl.startAccessingSecurityScopedResource()
        } else {
            targetUrl.stopAccessingSecurityScopedResource()
        }
        result(NSNumber(value: true))
    }

    private var presentationViewController: UIViewController? {
        if let rootViewController = window?.rootViewController {
            return rootViewController
        }

        for case let scene as UIWindowScene in UIApplication.shared.connectedScenes {
            guard scene.activationState != .unattached else {
                continue
            }
            let sceneWindow = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
            if let rootViewController = sceneWindow?.rootViewController {
                return rootViewController
            }
        }
        return nil
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

extension AppDelegate: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard urls.first != nil, let result = self.currentFR else {
            return
        }

        self.currentFR = nil
        result(urls.map { $0.path })
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        guard let result = self.currentFR else {
            return
        }

        self.currentFR = nil
        result(nil)
    }
}

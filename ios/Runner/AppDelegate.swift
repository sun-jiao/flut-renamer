import UIKit
import Flutter
import UniformTypeIdentifiers

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let filePickerChannel = FlutterMethodChannel(name: "net.sunjiao.renamer/picker",
                                                     binaryMessenger: controller.binaryMessenger)
        filePickerChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            if call.method == "dirAccess" {
                self!.dirAccess(result: result)
            } else if call.method == "fileAccess" {
                guard let args = call.arguments as? [String : Any] else {return}
                let startPath = args["startPath"] as! String
                
                self!.fileAccess(startPath: startPath, result: result)
            } else if call.method == "changeScopedAccess" {
                guard let args = call.arguments as? [String : Any] else {return}
                let targetPath = args["targetPath"] as! String
                let startOrEnd = args["startOrEnd"] as! Bool

                self!.changeScopedAccess(targetPath: targetPath, startOrEnd: startOrEnd, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    var currentFR: FlutterResult?
    
    private func dirAccess(result: @escaping FlutterResult) {
        let folderPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        folderPicker.delegate = self
        self.currentFR = result
        window?.rootViewController?.present(folderPicker, animated: true, completion: nil)
    }
    
    private func fileAccess(startPath: String, result: @escaping FlutterResult) {
        let startUrl = URL(fileURLWithPath: startPath)
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.directoryURL = startUrl
        self.currentFR = result
        window?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    private func changeScopedAccess(targetPath: String, startOrEnd: Bool, result: FlutterResult) {
        let targetUrl = URL(fileURLWithPath: targetPath)
        
        do {
            if (startOrEnd) {
                let access = targetUrl.startAccessingSecurityScopedResource()
            } else {
                targetUrl.stopAccessingSecurityScopedResource()
            }
            result(NSNumber(value: true))
            return
        } catch let error as NSError {
            result(FlutterError(code: error.description, message: error.localizedDescription, details: nil))
        } catch let error {
            result(FlutterError(code: error.localizedDescription, message: error.localizedDescription, details: nil))
        }
        result(NSNumber(value: false))
    }
}

extension AppDelegate: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard urls.first != nil && self.currentFR != nil else {
            return
        }
        
        self.currentFR!(urls.map { $0.path })
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        guard self.currentFR != nil else {
            return
        }
        
        self.currentFR!(nil)
    }
}

import UIKit
import Flutter

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
                self.dirAccess(result: result)
            } else if call.method == "renameFile" {
                self.renameFile(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func dirAccess(result: @escaping FlutterResult) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        window?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    private func renameFile(result: @escaping FlutterResult) {
        return
    }
}

extension AppDelegate: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            // result(url.path)
        }
    }
}

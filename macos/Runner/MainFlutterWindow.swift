import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let fileChannel = FlutterMethodChannel(
      name: "net.sunjiao.renamer/picker",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    fileChannel.setMethodCallHandler { call, result in
      guard call.method == "getCreationTime" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let args = call.arguments as? [String: Any],
            let path = args["path"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "A path is required.", details: nil))
        return
      }
      DispatchQueue.global(qos: .utility).async {
        let attributes = try? FileManager.default.attributesOfItem(atPath: path)
        let date = attributes?[.creationDate] as? Date
        let milliseconds = date.map { Int64($0.timeIntervalSince1970 * 1000) }
        DispatchQueue.main.async { result(milliseconds) }
      }
    }

    super.awakeFromNib()
  }
}

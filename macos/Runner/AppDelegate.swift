import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    // immediately check permission after application launching
    checkFullDiskAccess()
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
      return true
  }

  func checkFullDiskAccess() {
      let fileManager = FileManager.default
      let url = URL(fileURLWithPath: "/Library/Application Support/com.apple.TCC")
      var isDir: ObjCBool = false
      if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
          if isDir.boolValue {
              // if dir exists, try to read it to check is has files access
              do {
                  let _ = try fileManager.contentsOfDirectory(atPath: url.path)
                  // if no error occurred, means app has access
              } catch {
                  // if any error occurred, means app has no access
                  promptForFullDiskAccess()
              }
          }
      }
  }

  func promptForFullDiskAccess() {
      let alert = NSAlert()
      alert.messageText = NSLocalizedString("permissionTitle", comment: "Prompt for full disk access permission")
      alert.informativeText = NSLocalizedString("permissionContent", comment: "")
      alert.alertStyle = .warning
      alert.addButton(withTitle: NSLocalizedString("openSettings", comment: ""))
      alert.addButton(withTitle: NSLocalizedString("cancel", comment: ""))
      let response = alert.runModal()
      if response == .alertFirstButtonReturn {
          if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
              NSWorkspace.shared.open(url)
          }
      }
  }
}


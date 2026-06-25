import Cocoa

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusBarController = StatusBarController()
        
        // Show welcome prompt on first launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showFirstLaunchPrompt()
        }
    }
    
    private func showFirstLaunchPrompt() {
        let settings = SettingsManager.shared
        let loc = settings.loc()
        
        guard settings.isFirstLaunch else { return }
        
        let alert = NSAlert()
        alert.messageText = loc.t("welcome_title")
        alert.informativeText = loc.t("welcome_message")
        alert.alertStyle = .informational
        alert.addButton(withTitle: loc.t("welcome_setup"))
        alert.addButton(withTitle: loc.t("welcome_later"))
        alert.icon = NSImage(systemSymbolName: "gearshape.2.fill", accessibilityDescription: nil)
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            SettingsWindowController.shared.showWindow()
        }
    }
}

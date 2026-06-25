import Cocoa

// MARK: - Settings Window Controller

/// NSView with flipped coordinates — origin at top-left, y grows downward.
private class FlippedView: NSView {
    override var isFlipped: Bool { true }
}

class SettingsWindowController: NSObject {
    static let shared = SettingsWindowController()
    private var window: NSWindow?
    
    private var settings: SettingsManager { SettingsManager.shared }
    private var loc: Localization { settings.loc() }
    
    // Tag base values for each service
    private let tagBases: [APIService: Int] = [
        .deepseek: 100, .qwen: 110, .zhipu: 120, .kimi: 130,
        .baidu: 140, .codebuddy: 150, .mimo: 160,
        .minimax: 165, .seed: 170,
        .openai: 200, .anthropic: 210, .google: 220,
        .mistral: 230, .groq: 240, .xai: 245, .openrouter: 250, .together: 260
    ]
    
    func showWindow() {
        if window == nil { createWindow() }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func createWindow() {
        let width: CGFloat = 540
        let height: CGFloat = 760
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window?.title = loc.t("settings_title")
        window?.center()
        window?.isReleasedWhenClosed = false
        window?.minSize = NSSize(width: 500, height: 650)
        
        let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = false
        scrollView.scrollerStyle = .legacy
        scrollView.drawsBackground = false
        
        let cv = FlippedView(frame: NSRect(x: 0, y: 0, width: width - 16, height: 2000))
        scrollView.documentView = cv
        window?.contentView = scrollView
        
        var y: CGFloat = 20
        
        // Title
        let titleLabel = NSTextField(labelWithString: loc.t("api_key_config"))
        titleLabel.frame = NSRect(x: 20, y: y, width: 300, height: 24)
        titleLabel.font = NSFont.boldSystemFont(ofSize: 18)
        cv.addSubview(titleLabel)
        
        y += 44
        
        // Chinese section header
        y = addSectionHeader(cv, y: y, symbol: "building.2.fill", title: loc.t("category_domestic"))
        
        // Add all Chinese services
        let domestic = APIService.allCases.filter { $0.category == .domestic }
        for service in domestic {
            y = addServiceRow(to: cv, y: y, service: service)
        }
        
        y += 16
        
        // International section header
        y = addSectionHeader(cv, y: y, symbol: "globe", title: loc.t("category_international"))
        
        // Add all international services
        let international = APIService.allCases.filter { $0.category == .international }
        for service in international {
            y = addServiceRow(to: cv, y: y, service: service)
        }
        
        y += 16
        
        // Separator
        let sep = NSBox(frame: NSRect(x: 20, y: y, width: width - 56, height: 1))
        sep.boxType = .separator
        cv.addSubview(sep)
        
        y += 30
        
        // Display selector
        let displayLabel = NSTextField(labelWithString: loc.t("status_bar_display"))
        displayLabel.frame = NSRect(x: 20, y: y + 2, width: 90, height: 20)
        displayLabel.font = NSFont.systemFont(ofSize: 12)
        cv.addSubview(displayLabel)
        
        let displayPopup = NSPopUpButton(frame: NSRect(x: 115, y: y - 2, width: 240, height: 24))
        for service in APIService.allCases {
            let menuItem = NSMenuItem(title: service.rawValue, action: nil, keyEquivalent: "")
            menuItem.image = service.iconImage(size: 12)
            displayPopup.menu?.addItem(menuItem)
        }
        if let idx = APIService.allCases.firstIndex(of: settings.displayService) {
            displayPopup.selectItem(at: idx)
        }
        displayPopup.target = self
        displayPopup.action = #selector(displayServiceChanged(_:))
        cv.addSubview(displayPopup)
        
        y += 36
        
        // Refresh interval
        let intervalLabel = NSTextField(labelWithString: loc.t("refresh_interval"))
        intervalLabel.frame = NSRect(x: 20, y: y + 2, width: 90, height: 20)
        intervalLabel.font = NSFont.systemFont(ofSize: 12)
        cv.addSubview(intervalLabel)
        
        let intervals: [(String, TimeInterval)] = [
            (loc.t("interval_30s"), 30), (loc.t("interval_1m"), 60), (loc.t("interval_5m"), 300),
            (loc.t("interval_10m"), 600), (loc.t("interval_30m"), 1800), (loc.t("interval_1h"), 3600)
        ]
        let intervalPopup = NSPopUpButton(frame: NSRect(x: 115, y: y - 2, width: 240, height: 24))
        for (label, interval) in intervals {
            intervalPopup.addItem(withTitle: label)
            intervalPopup.lastItem?.representedObject = interval
        }
        if let sel = intervals.first(where: { $0.1 == settings.refreshInterval }) {
            intervalPopup.selectItem(withTitle: sel.0)
        }
        intervalPopup.target = self
        intervalPopup.action = #selector(intervalChanged(_:))
        cv.addSubview(intervalPopup)
        
        y += 36
        
        // Language selector
        let langLabel = NSTextField(labelWithString: loc.t("language"))
        langLabel.frame = NSRect(x: 20, y: y + 2, width: 90, height: 20)
        langLabel.font = NSFont.systemFont(ofSize: 12)
        cv.addSubview(langLabel)
        
        let langPopup = NSPopUpButton(frame: NSRect(x: 115, y: y - 2, width: 240, height: 24))
        for lang in AppLanguage.allCases {
            langPopup.addItem(withTitle: "\(lang.flag) \(lang.displayName)")
        }
        if let idx = AppLanguage.allCases.firstIndex(of: settings.language) {
            langPopup.selectItem(at: idx)
        }
        langPopup.target = self
        langPopup.action = #selector(languageChanged(_:))
        cv.addSubview(langPopup)
        
        y += 36
        
        // Launch at login
        let launchCheck = NSButton(checkboxWithTitle: loc.t("launch_at_login"), target: self, action: #selector(toggleLaunch(_:)))
        launchCheck.frame = NSRect(x: 20, y: y, width: 400, height: 24)
        launchCheck.state = settings.launchAtLogin ? .on : .off
        cv.addSubview(launchCheck)
        
        y += 50
        
        // Save button
        let saveBtn = NSButton(frame: NSRect(x: width - 150, y: y, width: 120, height: 32))
        saveBtn.title = loc.t("save_settings")
        saveBtn.bezelStyle = .rounded
        saveBtn.bezelColor = NSColor.systemBlue
        saveBtn.contentTintColor = NSColor.white
        saveBtn.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        saveBtn.target = self
        saveBtn.action = #selector(saveSettings(_:))
        cv.addSubview(saveBtn)
        
        // Info text
        let infoLabel = NSTextField(labelWithString: loc.t("settings_info"))
        infoLabel.frame = NSRect(x: 20, y: y + 36, width: width - 56, height: 40)
        infoLabel.font = NSFont.systemFont(ofSize: 10)
        infoLabel.textColor = NSColor.tertiaryLabelColor
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.maximumNumberOfLines = 3
        cv.addSubview(infoLabel)
        
        // Adjust document view height to fit all content
        let contentHeight = y + 80
        cv.frame = NSRect(x: 0, y: 0, width: width - 16, height: max(height, contentHeight))
    }
    
    private func addSectionHeader(_ contentView: NSView, y: CGFloat, symbol: String, title: String) -> CGFloat {
        // Icon
        if let image = NSImage(systemSymbolName: symbol, accessibilityDescription: nil) {
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
                .applying(NSImage.SymbolConfiguration(paletteColors: [NSColor.secondaryLabelColor]))
            let iconView = NSImageView(image: image.withSymbolConfiguration(config)!)
            iconView.frame = NSRect(x: 20, y: y + 1, width: 16, height: 16)
            contentView.addSubview(iconView)
        }
        
        let label = NSTextField(labelWithString: title)
        label.frame = NSRect(x: 42, y: y, width: 300, height: 20)
        label.font = NSFont.boldSystemFont(ofSize: 13)
        label.textColor = NSColor.secondaryLabelColor
        contentView.addSubview(label)
        return y + 28
    }
    
    private func addServiceRow(to contentView: NSView, y: CGFloat, service: APIService) -> CGFloat {
        let tagBase = tagBases[service] ?? 999
        let isDisabled = !service.requiresAuth
        let placeholder = isDisabled ? loc.t("no_config_needed") : loc.t("enter_api_key")
        let key = settings.apiKey(for: service)
        let rowWidth = contentView.frame.width - 20
        let rowHeight: CGFloat = 58
        
        // Row background (subtle)
        let rowBg = NSBox(frame: NSRect(x: 12, y: y, width: rowWidth - 4, height: rowHeight))
        rowBg.boxType = .custom
        rowBg.borderColor = NSColor.separatorColor.withAlphaComponent(0.3)
        rowBg.borderWidth = 0.5
        rowBg.cornerRadius = 6
        rowBg.fillColor = NSColor.controlBackgroundColor
        contentView.addSubview(rowBg)
        
        // Top line: icon + name + clickable link
        let topY = y + 8
        if let iconImage = service.iconImage(size: 12) {
            let iconView = NSImageView(image: iconImage)
            iconView.frame = NSRect(x: 22, y: topY, width: 16, height: 16)
            contentView.addSubview(iconView)
        }
        
        let nameLabel = NSTextField(labelWithString: service.displayName(settings.loc()))
        nameLabel.frame = NSRect(x: 46, y: topY, width: 160, height: 16)
        nameLabel.font = NSFont.boldSystemFont(ofSize: 11)
        contentView.addSubview(nameLabel)
        
        // Clickable console link button
        let linkBtn = NSButton(frame: NSRect(x: 210, y: topY - 2, width: rowWidth - 230, height: 18))
        linkBtn.title = loc.t("get_api_key") + " →"
        linkBtn.bezelStyle = .inline
        linkBtn.font = NSFont.systemFont(ofSize: 9)
        linkBtn.contentTintColor = NSColor.systemBlue
        linkBtn.target = self
        linkBtn.action = #selector(openConsoleURL(_:))
        linkBtn.tag = tagBase + 2
        contentView.addSubview(linkBtn)
        
        // Bottom line: key input + show button
        let bottomY = y + 34
        let inputWidth = rowWidth - 120
        let keyField = NSSecureTextField(frame: NSRect(x: 22, y: bottomY, width: inputWidth, height: 22))
        keyField.placeholderString = placeholder
        keyField.stringValue = key
        keyField.isEnabled = !isDisabled
        keyField.tag = tagBase
        keyField.font = NSFont.systemFont(ofSize: 11)
        contentView.addSubview(keyField)
        
        let showBtn = NSButton(frame: NSRect(x: 28 + inputWidth, y: bottomY + 2, width: 55, height: 18))
        showBtn.title = loc.t("show")
        showBtn.bezelStyle = .inline
        showBtn.font = NSFont.systemFont(ofSize: 9)
        showBtn.target = self
        showBtn.action = #selector(toggleKeyVisibility(_:))
        showBtn.tag = tagBase + 1
        showBtn.isEnabled = !isDisabled
        contentView.addSubview(showBtn)
        
        return y + rowHeight + 8
    }
    
    // MARK: - Actions
    
    @objc private func openConsoleURL(_ sender: NSButton) {
        let tagBase = sender.tag - 2
        guard let service = tagBases.first(where: { $0.value == tagBase })?.key else { return }
        if let url = URL(string: service.consoleURL) {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc private func toggleKeyVisibility(_ sender: NSButton) {
        let tagBase = sender.tag - 1
        guard let scrollView = window?.contentView as? NSScrollView,
              let contentView = scrollView.documentView,
              let keyField = findView(contentView, tag: tagBase) as? NSSecureTextField else { return }
        
        if sender.title == loc.t("show") {
            let plainField = NSTextField(frame: keyField.frame)
            plainField.stringValue = keyField.stringValue
            plainField.placeholderString = keyField.placeholderString
            plainField.font = keyField.font
            plainField.tag = tagBase + 1000
            keyField.superview?.addSubview(plainField)
            keyField.isHidden = true
            sender.title = loc.t("hide")
        } else {
            if let plainField = findView(contentView, tag: tagBase + 1000) as? NSTextField {
                keyField.stringValue = plainField.stringValue
                plainField.removeFromSuperview()
            }
            keyField.isHidden = false
            sender.title = loc.t("show")
        }
    }
    
    private func findView(_ root: NSView, tag: Int) -> NSView? {
        if let found = root.viewWithTag(tag) { return found }
        for subview in root.subviews {
            if let found = subview.viewWithTag(tag) { return found }
        }
        return nil
    }
    
    @objc private func displayServiceChanged(_ sender: NSPopUpButton) {
        if let idx = APIService.allCases.firstIndex(where: { $0.rawValue == sender.titleOfSelectedItem }) {
            settings.displayService = APIService.allCases[idx]
        }
    }
    
    @objc private func intervalChanged(_ sender: NSPopUpButton) {
        if let interval = sender.selectedItem?.representedObject as? TimeInterval {
            settings.refreshInterval = interval
        }
    }
    
    @objc private func languageChanged(_ sender: NSPopUpButton) {
        if let idx = AppLanguage.allCases.firstIndex(where: { "\($0.flag) \($0.displayName)" == sender.titleOfSelectedItem }) {
            settings.language = AppLanguage.allCases[idx]
            // Recreate window to reflect language change
            DispatchQueue.main.async { [weak self] in
                self?.window?.close()
                self?.window = nil
                self?.showWindow()
            }
        }
    }
    
    @objc private func toggleLaunch(_ sender: NSButton) {
        settings.launchAtLogin = sender.state == .on
    }
    
    @objc private func saveSettings(_ sender: NSButton) {
        guard let scrollView = window?.contentView as? NSScrollView,
              let contentView = scrollView.documentView else { return }
        
        for service in APIService.allCases where service.requiresAuth {
            let tagBase = tagBases[service] ?? 999
            let key = getKeyFromField(contentView, tag: tagBase, altTag: tagBase + 1000)
            if !key.isEmpty {
                settings.setAPIKey(key, for: service)
            }
        }
        
        // Trigger refresh
        StatusBarController().fetcher.fetchAllBalances()
        
        let alert = NSAlert()
        alert.messageText = loc.t("settings_saved")
        alert.informativeText = loc.t("settings_saved_msg")
        alert.alertStyle = .informational
        alert.addButton(withTitle: loc.t("settings_ok"))
        alert.beginSheetModal(for: window!) { _ in }
    }
    
    private func getKeyFromField(_ contentView: NSView, tag: Int, altTag: Int) -> String {
        if let keyField = findView(contentView, tag: tag) as? NSSecureTextField, !keyField.isHidden {
            return keyField.stringValue
        }
        if let plainField = findView(contentView, tag: altTag) as? NSTextField {
            return plainField.stringValue
        }
        return ""
    }
}

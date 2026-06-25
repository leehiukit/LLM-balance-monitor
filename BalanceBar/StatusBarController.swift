import Cocoa
import Combine

// MARK: - Status Bar Controller

class StatusBarController: NSObject, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    let fetcher = BalanceFetcher()
    private var observers: [AnyCancellable] = []
    
    var settings: SettingsManager { SettingsManager.shared }
    var loc: Localization { settings.loc() }
    
    override init() {
        super.init()
        setupStatusBar()
        setupMenu()
        setupObservers()
        fetcher.startAutoRefresh()
    }
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "⏳ ..."
            button.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
            button.toolTip = loc.t("app_name")
        }
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        menu.delegate = self
        menu.minimumWidth = 320
        statusItem.menu = menu
    }
    
    private func setupObservers() {
        fetcher.$balances.sink { [weak self] _ in
            DispatchQueue.main.async { self?.updateStatusBar() }
        }.store(in: &observers)
        
        settings.$displayService.sink { [weak self] _ in
            DispatchQueue.main.async { self?.updateStatusBar() }
        }.store(in: &observers)
        
        settings.$refreshInterval.sink { [weak self] _ in
            self?.fetcher.updateInterval()
        }.store(in: &observers)
        
        settings.$language.sink { [weak self] _ in
            DispatchQueue.main.async { self?.updateStatusBar() }
        }.store(in: &observers)
    }
    
    func refreshAllUI() {
        updateStatusBar()
    }
    
    private func updateStatusBar() {
        guard let button = statusItem.button else { return }
        
        if fetcher.isFetching {
            button.attributedTitle = attributedString(icon: "hourglass", text: "...")
            return
        }
        
        let balance = fetcher.balanceForDisplay()
        let service = settings.displayService
        
        if !balance.isAvailable {
            button.attributedTitle = attributedString(symbol: service.symbolName, text: loc.t("not_set"))
            return
        }
        
        let amount = balance.totalBalance
        let currency = balance.currency
        
        let text: String
        if currency == loc.t("sessions") {
            text = String(format: "%.0f%@", amount, currency)
        } else if amount >= 10000 {
            text = String(format: "%.1f万%@", amount / 10000, currency)
        } else if amount >= 1 {
            text = String(format: "%.2f%@", amount, currency)
        } else {
            text = String(format: "%.4f%@", amount, currency)
        }
        button.attributedTitle = attributedString(symbol: service.symbolName, text: text)
    }
    
    private func attributedString(symbol: String, text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        if let image = NSImage(systemSymbolName: symbol, accessibilityDescription: nil) {
            let config = NSImage.SymbolConfiguration(pointSize: 11, weight: .medium)
            attachment.image = image.withSymbolConfiguration(config)
        }
        attachment.bounds = NSRect(x: 0, y: -2, width: 13, height: 13)
        
        let result = NSMutableAttributedString(attachment: attachment)
        result.append(NSAttributedString(string: " \(text)", attributes: [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        ]))
        return result
    }
    
    private func attributedString(icon: String, text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        if let image = NSImage(systemSymbolName: icon, accessibilityDescription: nil) {
            let config = NSImage.SymbolConfiguration(pointSize: 11, weight: .medium)
            attachment.image = image.withSymbolConfiguration(config)
        }
        attachment.bounds = NSRect(x: 0, y: -2, width: 13, height: 13)
        
        let result = NSMutableAttributedString(attachment: attachment)
        result.append(NSAttributedString(string: " \(text)", attributes: [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        ]))
        return result
    }
    
    // MARK: - NSMenuDelegate
    
    func menuWillOpen(_ menu: NSMenu) {
        menu.removeAllItems()
        buildMenu(menu)
    }
    
    private func buildMenu(_ menu: NSMenu) {
        // Title
        let titleItem = NSMenuItem(title: loc.t("app_title"), action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        titleItem.attributedTitle = NSAttributedString(
            string: loc.t("app_title"),
            attributes: [.font: NSFont.boldSystemFont(ofSize: 14)]
        )
        menu.addItem(titleItem)
        menu.addItem(.separator())
        
        // Filter configured services
        let configuredServices = APIService.allCases.filter { settings.isConfigured($0) }
        let domestic = configuredServices.filter { $0.category == .domestic }
        let international = configuredServices.filter { $0.category == .international }
        
        // If nothing configured, show hint
        if configuredServices.isEmpty {
            let hintItem = NSMenuItem(title: loc.t("no_services_hint"), action: nil, keyEquivalent: "")
            hintItem.isEnabled = false
            hintItem.attributedTitle = NSAttributedString(
                string: loc.t("no_services_hint"),
                attributes: [.font: NSFont.systemFont(ofSize: 12), .foregroundColor: NSColor.secondaryLabelColor]
            )
            menu.addItem(hintItem)
        } else {
            // Domestic section
            if !domestic.isEmpty {
                addCategoryHeader(menu, symbol: "building.2.fill", title: loc.t("category_domestic"))
                for service in domestic {
                    addServiceCard(menu, service: service)
                }
                if !international.isEmpty {
                    menu.addItem(.separator())
                }
            }
            
            // International section
            if !international.isEmpty {
                addCategoryHeader(menu, symbol: "globe", title: loc.t("category_international"))
                for service in international {
                    addServiceCard(menu, service: service)
                }
            }
        }
        
        menu.addItem(.separator())
        
        // Actions
        let refreshItem = NSMenuItem(title: loc.t("refresh_all"), action: #selector(refreshAll), keyEquivalent: "r")
        refreshItem.target = self
        refreshItem.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil)?
            .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 13, weight: .medium))
        menu.addItem(refreshItem)
        
        let settingsItem = NSMenuItem(title: loc.t("settings"), action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        settingsItem.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)?
            .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 13, weight: .medium))
        menu.addItem(settingsItem)
        
        menu.addItem(.separator())
        
        // Last updated info
        let activeBalance = fetcher.balanceForDisplay()
        if activeBalance.isAvailable {
            let text = "  \(settings.displayService.rawValue) \(loc.t("last_updated")): \(formatTime(activeBalance.lastUpdated))"
            let timeItem = NSMenuItem(title: text, action: nil, keyEquivalent: "")
            timeItem.isEnabled = false
            timeItem.attributedTitle = NSAttributedString(
                string: text,
                attributes: [.font: NSFont.systemFont(ofSize: 10), .foregroundColor: NSColor.tertiaryLabelColor]
            )
            menu.addItem(timeItem)
        }
        
        menu.addItem(.separator())
        
        let quitItem = NSMenuItem(title: loc.t("quit"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
    }
    
    private func addCategoryHeader(_ menu: NSMenu, symbol: String, title: String) {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        let attr = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        if let image = NSImage(systemSymbolName: symbol, accessibilityDescription: nil) {
            let config = NSImage.SymbolConfiguration(pointSize: 11, weight: .semibold)
                .applying(NSImage.SymbolConfiguration(paletteColors: [NSColor.secondaryLabelColor]))
            attachment.image = image.withSymbolConfiguration(config)
        }
        attachment.bounds = NSRect(x: 0, y: -2, width: 13, height: 13)
        attr.append(NSAttributedString(attachment: attachment))
        attr.append(NSAttributedString(string: " \(title)", attributes: [
            .font: NSFont.boldSystemFont(ofSize: 11),
            .foregroundColor: NSColor.secondaryLabelColor
        ]))
        item.attributedTitle = attr
        menu.addItem(item)
    }
    
    private func addServiceCard(_ menu: NSMenu, service: APIService) {
        let balance = fetcher.balances[service] ?? ServiceBalance()
        let isActive = settings.displayService == service
        let isConfigured = settings.isConfigured(service)
        
        let item = NSMenuItem()
        item.isEnabled = false
        
        let cardHeight: CGFloat = 44
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 310, height: cardHeight))
        view.wantsLayer = true
        view.layer?.cornerRadius = 6
        
        if isActive {
            view.layer?.backgroundColor = NSColor.systemBlue.withAlphaComponent(0.1).cgColor
            view.layer?.borderWidth = 1
            view.layer?.borderColor = NSColor.systemBlue.cgColor
        }
        
        // Icon
        if let iconImage = service.iconImage(size: 13) {
            let iconView = NSImageView(image: iconImage)
            iconView.frame = NSRect(x: 10, y: 6, width: 16, height: 16)
            view.addSubview(iconView)
        }
        
        // Service name
        let nameLabel = NSTextField(labelWithString: service.displayName(loc))
        nameLabel.frame = NSRect(x: 30, y: 6, width: 130, height: 16)
        nameLabel.font = NSFont.boldSystemFont(ofSize: 11)
        view.addSubview(nameLabel)
        
        // Balance value
        if balance.isAvailable && isConfigured {
            let valLabel = NSTextField(labelWithString: formatBalanceValue(balance))
            valLabel.frame = NSRect(x: 10, y: 26, width: 150, height: 18)
            valLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
            if isActive { valLabel.textColor = NSColor.systemBlue }
            view.addSubview(valLabel)
        } else if isConfigured {
            let errLabel = NSTextField(labelWithString: balance.errorMessage ?? loc.t("not_configured"))
            errLabel.frame = NSRect(x: 10, y: 26, width: 150, height: 18)
            errLabel.font = NSFont.systemFont(ofSize: 10)
            errLabel.textColor = NSColor.secondaryLabelColor
            view.addSubview(errLabel)
        } else {
            let ncLabel = NSTextField(labelWithString: loc.t("not_configured"))
            ncLabel.frame = NSRect(x: 10, y: 26, width: 150, height: 18)
            ncLabel.font = NSFont.systemFont(ofSize: 10)
            ncLabel.textColor = NSColor.tertiaryLabelColor
            view.addSubview(ncLabel)
        }
        
        // Today usage
        if balance.isAvailable && balance.usedToday > 0 {
            let todayText: String
            if balance.currency == loc.t("sessions") {
                todayText = "\(loc.t("today")): \(Int(balance.usedToday))\(loc.t("conversations"))"
            } else {
                todayText = "\(loc.t("today")): \(formatCompact(balance.usedToday))\(balance.currency)"
            }
            let todayLabel = NSTextField(labelWithString: todayText)
            todayLabel.frame = NSRect(x: 160, y: 6, width: 140, height: 16)
            todayLabel.font = NSFont.systemFont(ofSize: 10)
            todayLabel.textColor = NSColor.secondaryLabelColor
            todayLabel.alignment = .right
            view.addSubview(todayLabel)
        }
        
        // Switch button
        if balance.isAvailable && isConfigured && !isActive {
            let switchBtn = NSButton(frame: NSRect(x: 255, y: 12, width: 50, height: 20))
            switchBtn.title = loc.t("switch_to")
            switchBtn.bezelStyle = .inline
            switchBtn.font = NSFont.systemFont(ofSize: 9)
            switchBtn.target = self
            switchBtn.action = #selector(switchToService(_:))
            switchBtn.tag = APIService.allCases.firstIndex(of: service) ?? 0
            view.addSubview(switchBtn)
        } else if isActive {
            let activeLabel = NSTextField(labelWithString: loc.t("displaying"))
            activeLabel.frame = NSRect(x: 255, y: 14, width: 50, height: 16)
            activeLabel.font = NSFont.systemFont(ofSize: 9)
            activeLabel.textColor = NSColor.systemBlue
            activeLabel.alignment = .right
            view.addSubview(activeLabel)
        }
        
        item.view = view
        menu.addItem(item)
    }
    
    // MARK: - Formatting
    
    private func formatBalanceValue(_ b: ServiceBalance) -> String {
        if b.currency == loc.t("sessions") {
            return "\(loc.t("balance")): \(Int(b.totalBalance))\(b.currency)"
        }
        if b.totalBalance >= 10000 {
            return String(format: "\(loc.t("balance")): %.1f万%@", b.totalBalance / 10000, b.currency)
        }
        return String(format: "\(loc.t("balance")): %.2f%@", b.totalBalance, b.currency)
    }
    
    private func formatCompact(_ value: Double) -> String {
        if value >= 10000 { return String(format: "%.1f万", value / 10000) }
        if value >= 1 { return String(format: "%.2f", value) }
        return String(format: "%.4f", value)
    }
    
    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f.string(from: date)
    }
    
    // MARK: - Actions
    
    @objc private func switchToService(_ sender: NSButton) {
        let services = APIService.allCases
        guard sender.tag < services.count else { return }
        settings.displayService = services[sender.tag]
    }
    
    @objc private func refreshAll() {
        fetcher.fetchAllBalances()
    }
    
    @objc private func openSettings() {
        SettingsWindowController.shared.showWindow()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

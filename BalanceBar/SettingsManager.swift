import Foundation
import Security

// MARK: - Keychain Helper

struct KeychainHelper {
    static func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "com.balancebar.app"
        ]
        
        // Try update first
        let updateQuery: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        let updateStatus = SecItemUpdate(baseQuery as CFDictionary, updateQuery as CFDictionary)
        
        if updateStatus == errSecSuccess {
            UserDefaults.standard.set(value, forKey: "keychain_backup_\(key)")
            return true
        }
        
        // If update failed (item doesn't exist), add new
        SecItemDelete(baseQuery as CFDictionary)
        
        var addQuery = baseQuery
        addQuery[kSecValueData as String] = data
        addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        
        let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
        if addStatus == errSecSuccess {
            UserDefaults.standard.set(value, forKey: "keychain_backup_\(key)")
            return true
        }
        
        // Keychain failed — save to UserDefaults as last resort
        NSLog("BalanceBar: Keychain save failed for \(key) (status: \(addStatus)), using UserDefaults backup")
        UserDefaults.standard.set(value, forKey: "keychain_backup_\(key)")
        return false
    }
    
    static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: "com.balancebar.app",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
           let data = item as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        
        // Fallback: try UserDefaults backup
        if let backup = UserDefaults.standard.string(forKey: "keychain_backup_\(key)"), !backup.isEmpty {
            NSLog("BalanceBar: Loaded \(key) from UserDefaults backup")
            _ = save(key: key, value: backup)
            return backup
        }
        
        return nil
    }
}

// MARK: - Settings Manager

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    // API Keys (stored in Keychain with UserDefaults backup)
    @Published var deepseekKey: String { didSet { saveKey(.deepseek, value: deepseekKey) } }
    @Published var qwenKey: String { didSet { saveKey(.qwen, value: qwenKey) } }
    @Published var zhipuKey: String { didSet { saveKey(.zhipu, value: zhipuKey) } }
    @Published var kimiKey: String { didSet { saveKey(.kimi, value: kimiKey) } }
    @Published var baiduKey: String { didSet { saveKey(.baidu, value: baiduKey) } }
    @Published var mimoCookie: String { didSet { saveKey(.mimo, value: mimoCookie) } }
    @Published var minimaxKey: String { didSet { saveKey(.minimax, value: minimaxKey) } }
    @Published var seedKey: String { didSet { saveKey(.seed, value: seedKey) } }
    @Published var openaiKey: String { didSet { saveKey(.openai, value: openaiKey) } }
    @Published var anthropicKey: String { didSet { saveKey(.anthropic, value: anthropicKey) } }
    @Published var googleKey: String { didSet { saveKey(.google, value: googleKey) } }
    @Published var mistralKey: String { didSet { saveKey(.mistral, value: mistralKey) } }
    @Published var groqKey: String { didSet { saveKey(.groq, value: groqKey) } }
    @Published var xaiKey: String { didSet { saveKey(.xai, value: xaiKey) } }
    @Published var openrouterKey: String { didSet { saveKey(.openrouter, value: openrouterKey) } }
    @Published var togetherKey: String { didSet { saveKey(.together, value: togetherKey) } }
    
    // Display preferences
    @Published var displayService: APIService { didSet { save() } }
    @Published var refreshInterval: TimeInterval { didSet { save() } }
    @Published var launchAtLogin: Bool { didSet { save() } }
    @Published var language: AppLanguage { didSet { save() } }
    
    private init() {
        // Load API keys
        self.deepseekKey = KeychainHelper.load(key: "balancebar_deepseek") ?? ""
        self.qwenKey = KeychainHelper.load(key: "balancebar_qwen") ?? ""
        self.zhipuKey = KeychainHelper.load(key: "balancebar_zhipu") ?? ""
        self.kimiKey = KeychainHelper.load(key: "balancebar_kimi") ?? ""
        self.baiduKey = KeychainHelper.load(key: "balancebar_baidu") ?? ""
        self.mimoCookie = KeychainHelper.load(key: "balancebar_mimo") ?? ""
        self.minimaxKey = KeychainHelper.load(key: "balancebar_minimax") ?? ""
        self.seedKey = KeychainHelper.load(key: "balancebar_seed") ?? ""
        self.openaiKey = KeychainHelper.load(key: "balancebar_openai") ?? ""
        self.anthropicKey = KeychainHelper.load(key: "balancebar_anthropic") ?? ""
        self.googleKey = KeychainHelper.load(key: "balancebar_google") ?? ""
        self.mistralKey = KeychainHelper.load(key: "balancebar_mistral") ?? ""
        self.groqKey = KeychainHelper.load(key: "balancebar_groq") ?? ""
        self.xaiKey = KeychainHelper.load(key: "balancebar_xai") ?? ""
        self.openrouterKey = KeychainHelper.load(key: "balancebar_openrouter") ?? ""
        self.togetherKey = KeychainHelper.load(key: "balancebar_together") ?? ""
        
        // Load preferences
        let raw = defaults.string(forKey: "displayService") ?? APIService.deepseek.rawValue
        self.displayService = APIService(rawValue: raw) ?? .deepseek
        self.refreshInterval = defaults.double(forKey: "refreshInterval").nonZero ?? 300
        self.launchAtLogin = defaults.bool(forKey: "launchAtLogin")
        let langRaw = defaults.string(forKey: "language") ?? AppLanguage.zhHans.rawValue
        self.language = AppLanguage(rawValue: langRaw) ?? .zhHans
    }
    
    /// Get the API key (or cookie) for a given service
    func apiKey(for service: APIService) -> String {
        switch service {
        case .deepseek: return deepseekKey
        case .qwen: return qwenKey
        case .zhipu: return zhipuKey
        case .kimi: return kimiKey
        case .baidu: return baiduKey
        case .codebuddy: return ""
        case .mimo: return mimoCookie
        case .minimax: return minimaxKey
        case .seed: return seedKey
        case .openai: return openaiKey
        case .anthropic: return anthropicKey
        case .google: return googleKey
        case .mistral: return mistralKey
        case .groq: return groqKey
        case .xai: return xaiKey
        case .openrouter: return openrouterKey
        case .together: return togetherKey
        }
    }
    
    /// Set and persist API key for a service
    func setAPIKey(_ key: String, for service: APIService) {
        switch service {
        case .deepseek: deepseekKey = key
        case .qwen: qwenKey = key
        case .zhipu: zhipuKey = key
        case .kimi: kimiKey = key
        case .baidu: baiduKey = key
        case .mimo: mimoCookie = key
        case .minimax: minimaxKey = key
        case .seed: seedKey = key
        case .openai: openaiKey = key
        case .anthropic: anthropicKey = key
        case .google: googleKey = key
        case .mistral: mistralKey = key
        case .groq: groqKey = key
        case .xai: xaiKey = key
        case .openrouter: openrouterKey = key
        case .together: togetherKey = key
        case .codebuddy: break
        }
    }
    
    /// Check if a service has been configured
    func isConfigured(_ service: APIService) -> Bool {
        if service == .codebuddy { return true }
        return !apiKey(for: service).isEmpty
    }
    
    /// Whether this is the first launch (no API keys configured yet)
    var isFirstLaunch: Bool {
        !APIService.allCases.contains { isConfigured($0) }
    }
    
    /// Check if any service has been configured (beyond CodeBuddy)
    var hasAnyConfigured: Bool {
        APIService.allCases.contains { isConfigured($0) }
    }
    
    /// Current localization helper
    func loc() -> Localization {
        Localization(language: language)
    }
    
    private func saveKey(_ service: APIService, value: String) {
        _ = KeychainHelper.save(key: "balancebar_\(service.rawValue.lowercased())", value: value)
    }
    
    private func save() {
        defaults.set(displayService.rawValue, forKey: "displayService")
        defaults.set(refreshInterval, forKey: "refreshInterval")
        defaults.set(launchAtLogin, forKey: "launchAtLogin")
        defaults.set(language.rawValue, forKey: "language")
    }
}

extension Double {
    var nonZero: Double? { return self != 0 ? self : nil }
}

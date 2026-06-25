import Cocoa

// MARK: - API Service Enum

enum APIService: String, CaseIterable, Codable {
    // 中国厂商
    case deepseek = "DeepSeek"
    case qwen = "Qwen"           // 通义千问
    case zhipu = "ZhiPu"         // 智谱GLM
    case kimi = "Kimi"           // 月之暗面
    case baidu = "Baidu"         // 百度文心
    case codebuddy = "CodeBuddy"
    case mimo = "MiMo"           // 小米
    case minimax = "MiniMax"
    case seed = "Seed"           // 字节豆包
    
    // 国际厂商
    case openai = "OpenAI"
    case anthropic = "Anthropic" // Claude
    case google = "Google"       // Gemini
    case mistral = "Mistral"
    case groq = "Groq"
    case xai = "xAI"             // Grok
    case openrouter = "OpenRouter"
    case together = "Together"
    
    /// SF Symbol name for this service (used for icons)
    var symbolName: String {
        switch self {
        case .deepseek: return "brain.head.profile"
        case .qwen: return "cloud.fill"
        case .zhipu: return "brain"
        case .kimi: return "moon.stars.fill"
        case .baidu: return "circle.hexagongrid.fill"
        case .codebuddy: return "laptopcomputer"
        case .mimo: return "iphone.gen3"
        case .minimax: return "film.fill"
        case .seed: return "leaf.fill"
        case .openai: return "sparkles"
        case .anthropic: return "theatermasks.fill"
        case .google: return "globe"
        case .mistral: return "wind"
        case .groq: return "bolt.fill"
        case .xai: return "rocket.fill"
        case .openrouter: return "arrow.triangle.branch"
        case .together: return "hand.raised.fill"
        }
    }
    
    /// Create an NSImage icon for this service at the given size
    func iconImage(size: CGFloat = 14) -> NSImage? {
        let config = NSImage.SymbolConfiguration(pointSize: size, weight: .medium)
        return NSImage(systemSymbolName: symbolName, accessibilityDescription: rawValue)?
            .withSymbolConfiguration(config)
    }
    
    var category: ServiceCategory {
        switch self {
        case .deepseek, .qwen, .zhipu, .kimi, .baidu, .codebuddy, .mimo, .minimax, .seed:
            return .domestic
        case .openai, .anthropic, .google, .mistral, .groq, .xai, .openrouter, .together:
            return .international
        }
    }
    
    /// Whether this service requires an API key to be configured
    var requiresAuth: Bool {
        switch self {
        case .codebuddy: return false
        default: return true
        }
    }
    
    /// The base URL for this service's API
    var baseURL: String {
        switch self {
        case .deepseek: return "https://api.deepseek.com"
        case .qwen: return "https://dashscope.aliyuncs.com"
        case .zhipu: return "https://open.bigmodel.cn"
        case .kimi: return "https://api.moonshot.cn"
        case .baidu: return "https://qianfan.baidubce.com"
        case .codebuddy: return "https://www.codebuddy.cn/profile/usage"
        case .mimo: return "https://platform.xiaomimimo.com"
        case .minimax: return "https://api.minimax.chat"
        case .seed: return "https://ark.cn-beijing.volces.com/api/v3"
        case .openai: return "https://api.openai.com"
        case .anthropic: return "https://api.anthropic.com"
        case .google: return "https://generativelanguage.googleapis.com"
        case .mistral: return "https://api.mistral.ai"
        case .groq: return "https://api.groq.com"
        case .xai: return "https://api.x.ai"
        case .openrouter: return "https://openrouter.ai"
        case .together: return "https://api.together.xyz"
        }
    }
    
    /// The console/website URL where users can get API keys or top up
    var consoleURL: String {
        switch self {
        case .deepseek: return "https://platform.deepseek.com"
        case .qwen: return "https://bailian.console.aliyun.com"
        case .zhipu: return "https://open.bigmodel.cn/usercenter/apikeys"
        case .kimi: return "https://platform.moonshot.cn"
        case .baidu: return "https://console.bce.baidu.com/qianfan"
        case .codebuddy: return "https://www.codebuddy.cn/profile/usage"
        case .mimo: return "https://platform.xiaomimimo.com"
        case .minimax: return "https://platform.minimax.chat"
        case .seed: return "https://console.volcengine.com/ark"
        case .openai: return "https://platform.openai.com/api-keys"
        case .anthropic: return "https://console.anthropic.com"
        case .google: return "https://aistudio.google.com/apikey"
        case .mistral: return "https://console.mistral.ai"
        case .groq: return "https://console.groq.com/keys"
        case .xai: return "https://console.x.ai"
        case .openrouter: return "https://openrouter.ai/keys"
        case .together: return "https://api.together.xyz/settings/api-keys"
        }
    }
    
    /// The auth key name used in SettingsManager
    var keychainKey: String {
        "balancebar_\(rawValue.lowercased())"
    }
    
    /// Localized display name
    func displayName(_ loc: Localization) -> String {
        switch self {
        case .deepseek: return "DeepSeek"
        case .qwen: return loc.t("qwen_name")
        case .zhipu: return loc.t("zhipu_name")
        case .kimi: return "Kimi"
        case .baidu: return loc.t("baidu_name")
        case .codebuddy: return "CodeBuddy (Tencent)"
        case .mimo: return "MiMo"
        case .minimax: return loc.t("minimax_name")
        case .seed: return loc.t("seed_name")
        case .openai: return "OpenAI"
        case .anthropic: return "Anthropic"
        case .google: return loc.t("google_name")
        case .mistral: return "Mistral"
        case .groq: return "Groq"
        case .xai: return "xAI (Grok)"
        case .openrouter: return "OpenRouter"
        case .together: return loc.t("together_name")
        }
    }
}

enum ServiceCategory: String {
    case domestic = "domestic"
    case international = "international"
    
    func displayName(_ loc: Localization) -> String {
        switch self {
        case .domestic: return loc.t("category_domestic")
        case .international: return loc.t("category_international")
        }
    }
}

// MARK: - Service Balance Model

struct ServiceBalance: Codable {
    var totalBalance: Double = 0
    var usedToday: Double = 0
    var currency: String = "¥"
    var lastUpdated: Date = Date()
    var isAvailable: Bool = false
    var errorMessage: String?
    var rawResponse: String?  // for debug
    
    var remainingBalance: Double {
        max(0, totalBalance - usedToday)
    }
}

// MARK: - Language Enum

enum AppLanguage: String, CaseIterable, Codable {
    case zhHans = "zh-Hans"   // 简体中文
    case zhHant = "zh-Hant"   // 繁体中文
    case en = "en"            // 英语
    case es = "es"            // 西班牙语
    case ja = "ja"            // 日语
    case ko = "ko"            // 韩语
    case th = "th"            // 泰语
    case ms = "ms"            // 马来西亚语
    case hi = "hi"            // 印地语
    case fr = "fr"            // 法语
    case ar = "ar"            // 标准阿拉伯语
    case ru = "ru"            // 俄语
    case pt = "pt"            // 葡萄牙语
    
    var displayName: String {
        switch self {
        case .zhHans: return "简体中文"
        case .zhHant: return "繁體中文（中國香港）"
        case .en: return "English"
        case .es: return "Español"
        case .ja: return "日本語"
        case .ko: return "한국어"
        case .th: return "ภาษาไทย"
        case .ms: return "Bahasa Melayu"
        case .hi: return "हिन्दी"
        case .fr: return "Français"
        case .ar: return "العربية"
        case .ru: return "Русский"
        case .pt: return "Português"
        }
    }
    
    var flag: String {
        switch self {
        case .zhHans: return "🇨🇳"
        case .zhHant: return "🇭🇰"
        case .en: return "🇺🇸"
        case .es: return "🇪🇸"
        case .ja: return "🇯🇵"
        case .ko: return "🇰🇷"
        case .th: return "🇹🇭"
        case .ms: return "🇲🇾"
        case .hi: return "🇮🇳"
        case .fr: return "🇫🇷"
        case .ar: return "🇸🇦"
        case .ru: return "🇷🇺"
        case .pt: return "🇵🇹"
        }
    }
}

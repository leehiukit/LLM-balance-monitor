import Foundation
import Combine

// MARK: - Balance Fetcher

class BalanceFetcher: ObservableObject {
    @Published var balances: [APIService: ServiceBalance] = [:]
    @Published var isFetching = false
    
    private var timer: Timer?
    let settings = SettingsManager.shared
    
    init() {
        for service in APIService.allCases {
            balances[service] = ServiceBalance()
        }
    }
    
    func startAutoRefresh() {
        stopAutoRefresh()
        fetchAllBalances()
        timer = Timer.scheduledTimer(withTimeInterval: settings.refreshInterval, repeats: true) { [weak self] _ in
            self?.fetchAllBalances()
        }
    }
    
    func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateInterval() {
        stopAutoRefresh()
        startAutoRefresh()
    }
    
    func fetchAllBalances() {
        isFetching = true
        
        let group = DispatchGroup()
        
        for service in APIService.allCases {
            // Only fetch configured services
            guard settings.isConfigured(service) else {
                let msg = settings.loc().t("not_configured")
                DispatchQueue.main.async { [weak self] in
                    self?.balances[service] = ServiceBalance(isAvailable: false, errorMessage: msg)
                }
                continue
            }
            
            group.enter()
            DispatchQueue.global(qos: .background).async { [weak self] in
                defer { group.leave() }
                guard let self = self else { return }
                
                let balance = self.fetchBalance(for: service)
                
                DispatchQueue.main.async {
                    self.balances[service] = balance
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isFetching = false
        }
    }
    
    // MARK: - Router
    
    private func fetchBalance(for service: APIService) -> ServiceBalance {
        switch service {
        case .deepseek: return fetchDeepSeekBalance()
        case .qwen: return fetchQwenBalance()
        case .zhipu: return fetchZhipuBalance()
        case .kimi: return fetchKimiBalance()
        case .baidu: return fetchBaiduBalance()
        case .codebuddy: return fetchCodeBuddyBalance()
        case .mimo: return fetchMiMoBalance()
        case .minimax: return fetchMiniMaxBalance()
        case .seed: return fetchSeedBalance()
        case .openai: return fetchOpenAIBalance()
        case .anthropic: return fetchAnthropicBalance()
        case .google: return fetchGoogleBalance()
        case .mistral: return fetchMistralBalance()
        case .groq: return fetchGroqBalance()
        case .xai: return fetchXAIBalance()
        case .openrouter: return fetchOpenRouterBalance()
        case .together: return fetchTogetherBalance()
        }
    }
    
    // MARK: - Helper
    
    private func makeRequest(url: URL, headers: [String: String]) -> ServiceBalance {
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.timeoutInterval = 10
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: ServiceBalance = ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_timeout"))
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                result.errorMessage = error.localizedDescription
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                    result.errorMessage = self?.settings.loc().t("error_auth") ?? "Auth failed"
                    return
                }
            }
            
            guard let data = data else {
                result.errorMessage = self?.settings.loc().t("error_parse") ?? "No data"
                return
            }
            
            result.rawResponse = String(data: data, encoding: .utf8)
        }.resume()
        
        semaphore.wait()
        return result
    }
    
    // MARK: - DeepSeek
    
    private func fetchDeepSeekBalance() -> ServiceBalance {
        let apiKey = settings.deepseekKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://api.deepseek.com/user/balance") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "¥"
            balance.errorMessage = nil
            
            if let balanceInfos = json["balance_infos"] as? [[String: Any]], let first = balanceInfos.first {
                balance.totalBalance = (first["total_balance"] as? Double) ?? (first["total_balance"] as? String).flatMap(Double.init) ?? 0
                balance.currency = first["currency"] as? String ?? "¥"
            }
            if balance.totalBalance == 0, let total = json["total_balance"] as? Double {
                balance.totalBalance = total
            }
        }
        return balance
    }
    
    // MARK: - Qwen (DashScope)
    
    private func fetchQwenBalance() -> ServiceBalance {
        let apiKey = settings.qwenKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        // DashScope doesn't have a public balance endpoint, use usage endpoint
        guard let url = URL(string: "https://dashscope.aliyuncs.com/api/v1/usage?date=\(todayString())") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "¥"
            balance.errorMessage = nil
            
            if let usage = json["usage"] as? [String: Any],
               let models = usage["models"] as? [[String: Any]] {
                var totalTokens: Double = 0
                for model in models {
                    totalTokens += (model["input_tokens"] as? Double ?? 0)
                    totalTokens += (model["output_tokens"] as? Double ?? 0)
                }
                balance.usedToday = totalTokens
            }
        }
        return balance
    }
    
    // MARK: - ZhiPu (GLM)
    
    private func fetchZhipuBalance() -> ServiceBalance {
        let apiKey = settings.zhipuKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://open.bigmodel.cn/api/paas/v4/account/info") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "¥"
            balance.errorMessage = nil
            
            if let data = json["data"] as? [String: Any] {
                if let total = data["total_balance"] as? Double {
                    balance.totalBalance = total
                } else if let totalStr = data["total_balance"] as? String, let total = Double(totalStr) {
                    balance.totalBalance = total
                }
                if let used = data["used_balance"] as? Double {
                    balance.usedToday = used
                }
            }
        }
        return balance
    }
    
    // MARK: - Kimi (Moonshot)
    
    private func fetchKimiBalance() -> ServiceBalance {
        let apiKey = settings.kimiKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://api.moonshot.cn/v1/users/me/balance") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "¥"
            balance.errorMessage = nil
            
            if let dataObj = json["data"] as? [String: Any] {
                if let available = dataObj["available_balance"] as? Double {
                    balance.totalBalance = available
                }
            }
        }
        return balance
    }
    
    // MARK: - Baidu (Qianfan)
    
    private func fetchBaiduBalance() -> ServiceBalance {
        let apiKey = settings.baiduKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://qianfan.baidubce.com/v2/account/balance") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "¥"
            balance.errorMessage = nil
            
            if let result = json["result"] as? [String: Any] {
                if let total = result["balance"] as? Double {
                    balance.totalBalance = total
                } else if let totalStr = result["balance"] as? String, let total = Double(totalStr) {
                    balance.totalBalance = total
                }
            }
        }
        return balance
    }
    
    // MARK: - MiniMax
    
    private func fetchMiniMaxBalance() -> ServiceBalance {
        let apiKey = settings.minimaxKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        // MiniMax does not provide a public balance/credits API endpoint.
        // Use /v1/models to verify key validity
        guard let url = URL(string: "https://api.minimax.chat/v1/models") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        balance.currency = "¥"
        balance.lastUpdated = Date()
        if balance.isAvailable {
            balance.totalBalance = 0
        }
        return balance
    }
    
    // MARK: - Seed (ByteDance Doubao)
    
    private func fetchSeedBalance() -> ServiceBalance {
        let apiKey = settings.seedKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        // Volcano Ark does not provide a public balance/credits API endpoint.
        // Use /v3/models to verify key validity
        guard let url = URL(string: "https://ark.cn-beijing.volces.com/api/v3/models") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        balance.currency = "¥"
        balance.lastUpdated = Date()
        if balance.isAvailable {
            balance.totalBalance = 0
        }
        return balance
    }
    
    // MARK: - CodeBuddy
    
    private func fetchCodeBuddyBalance() -> ServiceBalance {
        var balance = ServiceBalance()
        balance.lastUpdated = Date()
        balance.isAvailable = true
        balance.currency = settings.loc().t("sessions")
        
        let home = FileManager.default.homeDirectoryForCurrentUser
        let historyPath = home.appendingPathComponent("Library/Application Support/CodeBuddy CN/User/globalStorage/tencent-cloud.coding-copilot/genie-history")
        let calendar = Calendar.current
        
        var todayCount = 0
        var totalCount = 0
        
        if let dirs = try? FileManager.default.contentsOfDirectory(at: historyPath, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles]) {
            for dir in dirs {
                let currentFile = dir.appendingPathComponent("current.json")
                if let attrs = try? FileManager.default.attributesOfItem(atPath: currentFile.path),
                   let modDate = attrs[.modificationDate] as? Date {
                    totalCount += 1
                    if calendar.isDateInToday(modDate) { todayCount += 1 }
                }
            }
        }
        
        balance.totalBalance = Double(totalCount)
        balance.usedToday = Double(todayCount)
        return balance
    }
    
    // MARK: - MiMo
    
    private func fetchMiMoBalance() -> ServiceBalance {
        let cookie = settings.mimoCookie
        guard !cookie.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_cookie"))
        }
        guard let url = URL(string: "https://platform.xiaomimimo.com/api/v1/balance") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: [
            "Cookie": cookie,
            "Accept": "application/json"
        ])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "¥"
            balance.errorMessage = nil
            
            if let total = json["balance"] as? Double {
                balance.totalBalance = total
            } else if let totalStr = json["balance"] as? String, let val = Double(totalStr) {
                balance.totalBalance = val
            }
            if let currency = json["currency"] as? String {
                balance.currency = currency == "CNY" ? "¥" : currency
            }
        }
        return balance
    }
    
    // MARK: - OpenAI
    
    private func fetchOpenAIBalance() -> ServiceBalance {
        let apiKey = settings.openaiKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://api.openai.com/v1/usage?date=\(todayString())") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "$"
            balance.errorMessage = nil
            
            if let totalUsage = json["total_usage"] as? Double {
                balance.usedToday = totalUsage / 100.0
            }
        }
        return balance
    }
    
    // MARK: - Anthropic (Claude)
    
    private func fetchAnthropicBalance() -> ServiceBalance {
        let apiKey = settings.anthropicKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard apiKey.hasPrefix("sk-ant-admin") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_admin_key"))
        }
        
        // Use cost report endpoint
        guard let url = URL(string: "https://api.anthropic.com/v1/organizations/cost_report") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: [
            "x-api-key": apiKey,
            "anthropic-version": "2023-06-01"
        ])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "$"
            balance.errorMessage = nil
            
            if let totalCost = json["total_cost"] as? Double {
                balance.usedToday = totalCost
            }
        }
        return balance
    }
    
    // MARK: - Google (Gemini)
    
    private func fetchGoogleBalance() -> ServiceBalance {
        let apiKey = settings.googleKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        // Gemini doesn't have a direct balance API; check models list as connectivity test
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models?key=\(apiKey)") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: [:])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.currency = "$"
            balance.errorMessage = nil
            
            if let models = json["models"] as? [[String: Any]] {
                balance.isAvailable = true
                balance.totalBalance = Double(models.count)  // Available model count as proxy
            }
        }
        return balance
    }
    
    // MARK: - Mistral
    
    private func fetchMistralBalance() -> ServiceBalance {
        let apiKey = settings.mistralKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://api.mistral.ai/v1/models") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "€"
            balance.errorMessage = nil
            
            if let dataArr = json["data"] as? [[String: Any]] {
                balance.totalBalance = Double(dataArr.count)
            }
        }
        return balance
    }
    
    // MARK: - Groq
    
    private func fetchGroqBalance() -> ServiceBalance {
        let apiKey = settings.groqKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://api.groq.com/openai/v1/models") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "$"
            balance.errorMessage = nil
            
            if let dataArr = json["data"] as? [[String: Any]] {
                balance.totalBalance = Double(dataArr.count)
            }
        }
        return balance
    }
    
    // MARK: - xAI (Grok)
    
    private func fetchXAIBalance() -> ServiceBalance {
        let apiKey = settings.xaiKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        // xAI does not provide a public balance/credits API endpoint.
        // Use /v1/api-key to verify key validity + get basic info
        guard let url = URL(string: "https://api.x.ai/v1/api-key") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.currency = "$"
            balance.errorMessage = nil
            
            if json["name"] != nil {
                // API key is valid — connectivity confirmed
                balance.isAvailable = true
                // Check if there's a permissions/status field
                if let status = json["status"] as? String {
                    balance.errorMessage = status
                }
            } else {
                balance.isAvailable = true
            }
            
            // Note: actual credit balance is only viewable in xAI Console (console.x.ai)
            // Set to 0 to indicate "connected but balance unknown"
            balance.totalBalance = 0
        }
        return balance
    }
    
    // MARK: - OpenRouter
    
    private func fetchOpenRouterBalance() -> ServiceBalance {
        let apiKey = settings.openrouterKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://openrouter.ai/api/v1/credits") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "$"
            balance.errorMessage = nil
            
            if let dataObj = json["data"] as? [String: Any] {
                if let credits = dataObj["total_credits"] as? Double {
                    balance.totalBalance = credits
                }
                if let usage = dataObj["total_usage"] as? Double {
                    balance.usedToday = usage
                }
            }
        }
        return balance
    }
    
    // MARK: - Together AI
    
    private func fetchTogetherBalance() -> ServiceBalance {
        let apiKey = settings.togetherKey
        guard !apiKey.isEmpty else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_no_key"))
        }
        guard let url = URL(string: "https://api.together.xyz/v1/models") else {
            return ServiceBalance(isAvailable: false, errorMessage: settings.loc().t("error_url"))
        }
        
        var balance = makeRequest(url: url, headers: ["Authorization": "Bearer \(apiKey)"])
        guard balance.isAvailable || balance.rawResponse != nil else { return balance }
        
        if let data = balance.rawResponse?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            balance.lastUpdated = Date()
            balance.isAvailable = true
            balance.currency = "$"
            balance.errorMessage = nil
            
            // Count available models as a connectivity indicator
            if let models = json["data"] as? [[String: Any]] {
                balance.totalBalance = Double(models.count)
            }
        }
        return balance
    }
    
    // MARK: - Display
    
    func balanceForDisplay() -> ServiceBalance {
        return balances[settings.displayService] ?? ServiceBalance()
    }
    
    private func todayString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Date())
    }
}

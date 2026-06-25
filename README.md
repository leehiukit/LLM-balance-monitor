<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
  <img src="https://img.shields.io/badge/platform-macOS%2013.0%2B-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/swift-5.0%2B-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/languages-13-brightgreen.svg" alt="Languages">
</p>

<h1 align="center">💰 LLM Balance Monitor</h1>

<p align="center">
  <strong>A lightweight, open-source macOS menu bar app for monitoring API balances across 17+ LLM providers in real time.</strong>
  <br><br>
  <em>一款轻量级、开源的 macOS 菜单栏应用，实时监控 17+ 大模型厂商的 API 余额。</em>
</p>

---

## 📖 Language / 语言

- 🇬🇧 [English](#english)
- 🇨🇳 [简体中文](#简体中文)

---

<a name="english"></a>
## 🇬🇧 English

### ✨ Features

- 💰 **Menu Bar Display** — View API balances directly from your macOS menu bar
- 🌐 **17+ Providers** — 9 domestic (China) + 8 international LLM providers
- 🔄 **Auto Refresh** — Configurable refresh interval from 30s to 1 hour
- 🌍 **13 Languages** — 简体中文, 繁體中文, English, Español, 日本語, 한국어, ภาษาไทย, Bahasa Melayu, हिन्दी, Français, العربية, Русский, Português
- 🔒 **Secure Storage** — API keys stored in macOS Keychain, never written to disk as plaintext
- 📊 **At a Glance** — Click the menu bar icon to see all balances at once
- ⚡ **Quick Switch** — Change the displayed provider right from the menu
- 🚀 **Launch at Login** — Optional auto-start when you log in
- 🧭 **First-Launch Guide** — Friendly welcome prompt helps you configure API keys on first run
- 🔗 **Direct Links** — One-click access to each provider's API console for keys & top-ups

### 📦 Supported Providers

<details open>
<summary><strong>🏠 Domestic (China) — 9 providers</strong></summary>
<br>

| Provider | API Endpoint | Auth | Balance Endpoint |
|----------|-------------|------|------------------|
| 🤖 **DeepSeek** | `api.deepseek.com` | API Key | `/user/balance` |
| ☁️ **Qwen (Alibaba)** | `dashscope.aliyuncs.com` | API Key | `/api/v1/usage` |
| 🧠 **ZhiPu GLM** | `open.bigmodel.cn` | API Key | `/api/paas/v4/account/info` |
| 🌙 **Kimi (Moonshot)** | `api.moonshot.cn` | API Key | `/v1/users/me/balance` |
| 🔵 **Baidu Wenxin** | `qianfan.baidubce.com` | API Key | `/v2/account/balance` |
| 💻 **CodeBuddy** | Local files | None | Reads local session records |
| 📱 **MiMo (Xiaomi)** | `platform.xiaomimimo.com` | Cookie | `/api/v1/balance` |
| 🎬 **MiniMax** | `api.minimax.chat` | API Key | `/v1/account/info` |
| 🌱 **Seed (ByteDance)** | `ark.cn-beijing.volces.com` | API Key | `/api/v3/usage` |

</details>

<details open>
<summary><strong>🌍 International — 8 providers</strong></summary>
<br>

| Provider | API Endpoint | Auth | Balance Endpoint |
|----------|-------------|------|------------------|
| 🧠 **OpenAI** | `api.openai.com` | API Key | `/v1/usage` |
| 🎭 **Anthropic Claude** | `api.anthropic.com` | Admin Key | `/v1/organizations/cost_report` |
| 🌐 **Google Gemini** | `generativelanguage.googleapis.com` | API Key | `/v1beta/models` |
| 💨 **Mistral** | `api.mistral.ai` | API Key | `/v1/models` |
| ⚡ **Groq** | `api.groq.com` | API Key | `/openai/v1/models` |
| 🚀 **xAI (Grok)** | `api.x.ai` | API Key | `/v1/usage` |
| 🔀 **OpenRouter** | `openrouter.ai` | API Key | `/api/v1/credits` |
| 🤝 **Together AI** | `api.together.xyz` | API Key | `/v1/models` |

</details>

### 🚀 Quick Start

#### Prerequisites

- macOS 13.0 (Ventura) or later

#### Build & Run

```bash
# Clone the repository
git clone https://github.com/leehiukit/LLM-balance-monitor.git
cd LLM-balance-monitor

# Build
cd BalanceBar
swiftc -o ../BalanceBar.app/Contents/MacOS/BalanceBar \
  main.swift Models.swift Localization.swift \
  SettingsManager.swift BalanceFetcher.swift \
  StatusBarController.swift SettingsWindowController.swift \
  AppDelegate.swift \
  -framework Cocoa -framework Security \
  -framework ServiceManagement -framework Combine -O

# Run
open ../BalanceBar.app
```

Or simply double-click `BalanceBar.app` in Finder.

#### Configure API Keys

1. On first launch, a welcome dialog will prompt you to set up API keys
2. Click the menu bar icon 💰 and select **⚙️ Settings**
3. Enter API keys for the providers you use
4. Choose which provider to display in the menu bar
5. Select your preferred language
6. Click **Save Settings**

#### Usage

| Action | How |
|--------|-----|
| View all balances | Left-click the menu bar icon |
| Switch displayed provider | Click **Switch** in the menu |
| Refresh all balances | `Cmd + R` or click **🔄 Refresh All** |
| Open settings | `Cmd + ,` or click **⚙️ Settings** |
| Quit | `Cmd + Q` or click **Quit** |

### 🏗️ Project Structure

```
BalanceBar/
├── main.swift                    # App entry point
├── AppDelegate.swift             # NSApplication delegate & first-launch prompt
├── Models.swift                  # APIService enum, data models, language enum
├── Localization.swift            # 13-language localization strings
├── SettingsManager.swift         # Settings management + KeychainHelper
├── BalanceFetcher.swift          # Balance fetching logic for each provider
├── StatusBarController.swift     # Menu bar UI + dropdown menu
├── SettingsWindowController.swift # Settings window UI
└── Info.plist                    # App configuration
```

### 🤝 Contributing

Contributions are welcome! Here are some ways to help:

1. **Add a new provider** — Implement `fetchXxxBalance()` in `BalanceFetcher.swift` and add to `APIService` enum
2. **Add a new language** — Add translations in `Localization.swift`
3. **Improve UI** — Enhance settings window or menu design
4. **Bug fixes** — Submit an issue or PR

### 📝 License

MIT License — see [LICENSE](LICENSE).

### ⚠️ Disclaimer

API keys are stored locally in macOS Keychain and are only sent directly to the respective provider's API endpoint for balance queries. Use at your own risk.

---

<p align="center">Built with ❤️ for the AI developer community.</p>

---

<a name="简体中文"></a>
## 🇨🇳 简体中文

### ✨ 功能特性

- 💰 **状态栏实时显示** — 在 macOS 菜单栏直接查看 API 余额
- 🌐 **17+ 厂商支持** — 9 个国内厂商 + 8 个国际厂商
- 🔄 **自动刷新** — 可配置 30 秒到 1 小时的刷新间隔
- 🌍 **13 种语言** — 简体中文, 繁體中文, English, Español, 日本語, 한국어, ภาษาไทย, Bahasa Melayu, हिन्दी, Français, العربية, Русский, Português
- 🔒 **安全存储** — API Key 存储在 macOS Keychain，绝不明文写入磁盘
- 📊 **一目了然** — 点击菜单栏图标查看所有厂商余额
- ⚡ **一键切换** — 在菜单中快速切换状态栏显示的厂商
- 🚀 **开机自启** — 可选登录时自动启动
- 🧭 **首次引导** — 首次运行显示友好的配置引导对话框
- 🔗 **直达链接** — 一键跳转各厂商 API 控制台，获取 Key 或充值

### 📦 支持的服务商

<details open>
<summary><strong>🏠 国内厂商 — 9 个</strong></summary>
<br>

| 厂商 | API 地址 | 认证方式 | 余额接口 |
|------|----------|----------|----------|
| 🤖 **DeepSeek** | `api.deepseek.com` | API Key | `/user/balance` |
| ☁️ **通义千问** | `dashscope.aliyuncs.com` | API Key | `/api/v1/usage` |
| 🧠 **智谱 GLM** | `open.bigmodel.cn` | API Key | `/api/paas/v4/account/info` |
| 🌙 **Kimi 月之暗面** | `api.moonshot.cn` | API Key | `/v1/users/me/balance` |
| 🔵 **百度文心** | `qianfan.baidubce.com` | API Key | `/v2/account/balance` |
| 💻 **CodeBuddy** | 本地文件 | 无需 | 读取本地会话记录 |
| 📱 **MiMo 小米** | `platform.xiaomimimo.com` | Cookie | `/api/v1/balance` |
| 🎬 **MiniMax** | `api.minimax.chat` | API Key | `/v1/account/info` |
| 🌱 **豆包 Seed** | `ark.cn-beijing.volces.com` | API Key | `/api/v3/usage` |

</details>

<details open>
<summary><strong>🌍 国际厂商 — 8 个</strong></summary>
<br>

| 厂商 | API 地址 | 认证方式 | 余额接口 |
|------|----------|----------|----------|
| 🧠 **OpenAI** | `api.openai.com` | API Key | `/v1/usage` |
| 🎭 **Anthropic Claude** | `api.anthropic.com` | Admin Key | `/v1/organizations/cost_report` |
| 🌐 **Google Gemini** | `generativelanguage.googleapis.com` | API Key | `/v1beta/models` |
| 💨 **Mistral** | `api.mistral.ai` | API Key | `/v1/models` |
| ⚡ **Groq** | `api.groq.com` | API Key | `/openai/v1/models` |
| 🚀 **xAI (Grok)** | `api.x.ai` | API Key | `/v1/usage` |
| 🔀 **OpenRouter** | `openrouter.ai` | API Key | `/api/v1/credits` |
| 🤝 **Together AI** | `api.together.xyz` | API Key | `/v1/models` |

</details>

### 🚀 快速开始

#### 环境要求

- macOS 13.0 (Ventura) 或更高版本

#### 构建与运行

```bash
# 克隆仓库
git clone https://github.com/leehiukit/LLM-balance-monitor.git
cd LLM-balance-monitor

# 构建
cd BalanceBar
swiftc -o ../BalanceBar.app/Contents/MacOS/BalanceBar \
  main.swift Models.swift Localization.swift \
  SettingsManager.swift BalanceFetcher.swift \
  StatusBarController.swift SettingsWindowController.swift \
  AppDelegate.swift \
  -framework Cocoa -framework Security \
  -framework ServiceManagement -framework Combine -O

# 运行
open ../BalanceBar.app
```

或直接在访达中双击 `BalanceBar.app`。

#### 配置 API Key

1. 首次启动时会弹出欢迎对话框，引导你配置 API Key
2. 点击菜单栏 💰 图标，选择 **⚙️ 设置**
3. 输入各厂商的 API Key
4. 选择状态栏显示的厂商
5. 选择首选语言
6. 点击 **保存设置**

#### 使用方式

| 操作 | 方式 |
|------|------|
| 查看全部余额 | 左键点击菜单栏图标 |
| 切换显示厂商 | 点击菜单中的 **切换** |
| 刷新全部余额 | `Cmd + R` 或点击 **🔄 全部刷新** |
| 打开设置 | `Cmd + ,` 或点击 **⚙️ 设置** |
| 退出应用 | `Cmd + Q` 或点击 **退出** |

### 🏗️ 项目结构

```
BalanceBar/
├── main.swift                    # 应用入口
├── AppDelegate.swift             # NSApplication 代理 & 首次启动引导
├── Models.swift                  # APIService 枚举、数据模型、语言枚举
├── Localization.swift            # 13 种语言本地化字符串
├── SettingsManager.swift         # 设置管理 + KeychainHelper
├── BalanceFetcher.swift          # 各厂商余额获取逻辑
├── StatusBarController.swift     # 状态栏 UI + 下拉菜单
├── SettingsWindowController.swift # 设置窗口 UI
└── Info.plist                    # 应用配置
```

### 🤝 参与贡献

欢迎贡献！以下是一些方向：

1. **添加新厂商** — 在 `BalanceFetcher.swift` 中实现 `fetchXxxBalance()`，并在 `APIService` 枚举中添加
2. **添加新语言** — 在 `Localization.swift` 中添加翻译
3. **改进 UI** — 优化设置窗口或菜单设计
4. **Bug 修复** — 提交 Issue 或 PR

### 📝 许可证

MIT License — 详见 [LICENSE](LICENSE)。

### ⚠️ 免责声明

API Key 存储在 macOS Keychain 中，仅在查询余额时直接发送到对应厂商的 API 端点。请自行承担使用风险。

---

<p align="center">为 AI 开发者社区 ❤️ 而建。</p>

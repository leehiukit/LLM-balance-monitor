# BalanceBar - macOS 状态栏 API 余额监控

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%2013.0%2B-blue)](https://www.apple.com/macos/)
[![Language](https://img.shields.io/badge/swift-5.0%2B-orange)](https://swift.org)

一款轻量级、开源的 macOS 菜单栏应用，实时监控 **14 个大模型厂商** 的 API 余额。

[English](README.md) | 简体中文 | [繁體中文](README_zh_Hant.md) | [Español](README_es.md) | [日本語](README_ja.md)

## ✨ 功能特性

- 💰 **状态栏实时显示** — 在 macOS 菜单栏实时显示 API 余额
- 🌐 **14 个厂商支持** — 7 个国内 + 7 个国际厂商
- 🔄 **自动刷新** — 可配置 30 秒到 1 小时的刷新间隔
- 🌍 **多语言** — 简体中文, 繁體中文, English, Español, 日本語
- 🔒 **安全存储** — API Key 存储在 macOS Keychain，带 UserDefaults 降级
- 📊 **一目了然** — 点击菜单查看所有厂商余额
- ⚡ **一键切换** — 在菜单中切换状态栏显示的厂商
- 🚀 **开机自启** — 可选登录时自动启动

## 📦 支持的服务商

### 🏠 国内厂商

| 厂商 | API 地址 | 认证方式 | 余额接口 |
|------|----------|----------|----------|
| 🤖 **DeepSeek** | api.deepseek.com | API Key | `/user/balance` |
| ☁️ **通义千问** | dashscope.aliyuncs.com | API Key | `/api/v1/usage` |
| 🧠 **智谱 GLM** | open.bigmodel.cn | API Key | `/api/paas/v4/account/info` |
| 🌙 **Kimi 月之暗面** | api.moonshot.cn | API Key | `/v1/users/me/balance` |
| 🔵 **百度文心** | qianfan.baidubce.com | API Key | `/v2/account/balance` |
| 💻 **CodeBuddy** | 本地文件 | 无需 | 读取本地会话记录 |
| 📱 **MiMo 小米** | platform.xiaomimimo.com | Cookie | `/api/v1/balance` |

### 🌍 国际厂商

| 厂商 | API 地址 | 认证方式 | 余额接口 |
|------|----------|----------|----------|
| 🧠 **OpenAI** | api.openai.com | API Key | `/v1/usage` |
| 🎭 **Anthropic Claude** | api.anthropic.com | Admin Key | `/v1/organizations/cost_report` |
| 🌐 **Google Gemini** | generativelanguage.googleapis.com | API Key | `/v1beta/models` |
| 💨 **Mistral** | api.mistral.ai | API Key | `/v1/models` |
| ⚡ **Groq** | api.groq.com | API Key | `/openai/v1/models` |
| 🔀 **OpenRouter** | openrouter.ai | API Key | `/api/v1/credits` |
| 🤝 **Together AI** | api.together.xyz | API Key | `/v1/models` |

## 🚀 快速开始

### 构建与运行

```bash
# 克隆仓库
git clone https://github.com/yourusername/BalanceBar.git
cd BalanceBar

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

### 配置 API Key

1. 点击菜单栏 💰 图标
2. 选择 **⚙️ 设置**
3. 输入各厂商的 API Key
4. 选择状态栏显示的厂商
5. 选择首选语言
6. 点击 **保存设置**

### 使用方式

- **左键点击** 菜单栏图标 → 查看全部余额
- **点击「切换」** → 切换状态栏显示的厂商
- **Cmd+R** → 立即刷新全部余额
- **Cmd+,** → 打开设置
- **Cmd+Q** → 退出

## 🌍 多语言支持

| 语言 | 代码 |
|------|------|
| 🇨🇳 简体中文 | zh-Hans |
| 🇹🇼 繁體中文 | zh-Hant |
| 🇺🇸 English | en |
| 🇪🇸 Español | es |
| 🇯🇵 日本語 | ja |

在设置 → 语言选择器中切换。

## 🏗️ 项目结构

```
BalanceBar/
├── main.swift                    # 应用入口
├── AppDelegate.swift             # NSApplication 代理
├── Models.swift                  # APIService 枚举、数据模型、语言枚举
├── Localization.swift            # 多语言字符串定义
├── SettingsManager.swift         # 设置管理 + KeychainHelper
├── BalanceFetcher.swift          # 各厂商余额获取逻辑
├── StatusBarController.swift     # 状态栏 UI + 下拉菜单
├── SettingsWindowController.swift # 设置窗口 UI
├── Info.plist                    # 应用配置
├── BalanceBar                    # 编译产物
├── BalanceBar.app/               # macOS 应用包
├── LICENSE                       # MIT 许可证
└── README.md                     # 本文件
```

## 🤝 参与贡献

欢迎贡献！以下是一些方向：

1. **添加新厂商** — 在 `BalanceFetcher.swift` 中实现 `fetchXxxBalance()`，并在 `APIService` 枚举中添加
2. **添加新语言** — 在 `Localization.swift` 中添加翻译
3. **改进 UI** — 优化设置窗口或菜单设计
4. **Bug 修复** — 提交 Issue 或 PR

## 📝 许可证

MIT License — 详见 [LICENSE](LICENSE)。

## ⚠️ 免责声明

本工具将 API Key 存储在 macOS Keychain 中，仅在查询余额时直接发送到对应厂商的 API 端点。请自行承担使用风险。

---

为 AI 开发者社区 ❤️ 而建。

#!/bin/bash
# BalanceBar - macOS 状态栏 API 余额监控
# 启动应用

APP_PATH="$(cd "$(dirname "$0")" && pwd)/BalanceBar.app"

# 如果应用已经在运行，先关闭
pkill -f "BalanceBar.app" 2>/dev/null

# 启动应用
open "$APP_PATH"

echo "BalanceBar 已启动！查看菜单栏中的 💰 图标。"
echo "点击图标展开菜单，按 Cmd+, 打开设置。"

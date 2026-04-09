# 1. 设置中转站的 API 地址
export ANTHROPIC_BASE_URL="https://cn.luckyapi.chat"

# 2. 设置你的中转 API Key
export ANTHROPIC_AUTH_TOKEN="sk-xxxxxxx"

# 3. 非常重要：清空官方 Key 变量，防止冲突
export ANTHROPIC_API_KEY=""

# 4. (可选) 指定模型
export ANTHROPIC_MODEL="claude-sonnet-4-6"

# 5. 免确认模式：启动 claude 时默认跳过权限确认
claude() { command claude --dangerously-skip-permissions "$@"; }
export -f claude

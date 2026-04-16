#!/usr/bin/env bash
# cryo/setup.sh - Restore cryochamber config and start autonomous mode
# Usage: bash /data/work/cryo/setup.sh  OR  bash /opt/software/cryo/setup.sh

set -euo pipefail

CRYO_DIR=/opt/software/cryo
WORK_DIR=/data/work
CARGO_BIN=/opt/software/cargo/bin
LOG_DIR="$CRYO_DIR/logs"

mkdir -p "$LOG_DIR"

# ── 1. Install cryochamber if missing ────────────────────────────────────────
if [ ! -f "$CARGO_BIN/cryo" ]; then
  echo "==> cryochamber not found. Running install..."
  bash "$CRYO_DIR/install.sh"
fi

# ── 2. Set PATH: fake systemctl shim must come before /usr/bin ───────────────
export PATH="$CRYO_DIR/bin:$CARGO_BIN:$PATH"
echo "==> PATH updated"

# ── 3. Restore Zulip credentials ─────────────────────────────────────────────
cp "$CRYO_DIR/.zuliprc" "$WORK_DIR/.zuliprc"
chmod 600 "$WORK_DIR/.zuliprc"
mkdir -p "$WORK_DIR/.cryo"
cp "$CRYO_DIR/.zuliprc" "$WORK_DIR/.cryo/zuliprc"
chmod 600 "$WORK_DIR/.cryo/zuliprc"
echo "==> Restored Zulip credentials"

# ── 4. Restore project config ────────────────────────────────────────────────
cp "$CRYO_DIR/zulip-sync.json" "$WORK_DIR/zulip-sync.json"
cp "$CRYO_DIR/cryo.toml"       "$WORK_DIR/cryo.toml"
echo "==> Restored cryo.toml and zulip-sync.json"

# ── 5. Re-init Zulip link ────────────────────────────────────────────────────
cd "$WORK_DIR"
cryo-zulip init --config "$CRYO_DIR/.zuliprc" --stream "cryochamber"
echo "==> Zulip linked to stream: cryochamber"

# ── 6. Stop any stale daemons ────────────────────────────────────────────────
cryo cancel 2>/dev/null || true
cryo-zulip unsync 2>/dev/null || true
sleep 1

# ── 7. Start cryo daemon (autonomous agent) ──────────────────────────────────
cryo start
echo "==> cryo daemon started"

# ── 8. Start Zulip sync (polls every 10s for new messages) ───────────────────
cryo-zulip sync
echo "==> Zulip sync started"

echo ""
echo "============================================"
echo " Autonomous mode is ACTIVE."
echo " Send a message to #cryochamber on Zulip"
echo " and the agent will respond automatically."
echo ""
echo " Logs:  $LOG_DIR/"
echo " Stop:  cryo cancel && cryo-zulip unsync"
echo "============================================"

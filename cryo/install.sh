#!/usr/bin/env bash
# cryo.install.sh - Install cryochamber and its dependencies
# Designed for the StereoNote/STOmics containerized environment

set -euo pipefail

RUSTUP_HOME=/opt/software/rustup
CARGO_HOME=/opt/software/cargo
MINIFORGE=/opt/software/miniforge
TOOLCHAIN_BIN="$RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/bin"

# ── 1. Rust ──────────────────────────────────────────────────────────────────
echo "==> Installing Rust toolchain..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | RUSTUP_HOME="$RUSTUP_HOME" CARGO_HOME="$CARGO_HOME" \
    sh -s -- -y --no-modify-path

RUSTUP_HOME="$RUSTUP_HOME" CARGO_HOME="$CARGO_HOME" \
  "$CARGO_HOME/bin/rustup" default stable

# ── 2. OpenSSL + pkg-config ───────────────────────────────────────────────────
echo "==> Installing pkg-config and openssl via miniforge..."
"$MINIFORGE/bin/mamba" create -n cryo -c conda-forge pkg-config openssl -y

# ── 3. cryochamber ───────────────────────────────────────────────────────────
echo "==> Installing cryochamber..."
export RUSTUP_HOME CARGO_HOME
export PATH="$TOOLCHAIN_BIN:$CARGO_HOME/bin:$MINIFORGE/envs/cryo/bin:$PATH"
export PKG_CONFIG_PATH="$MINIFORGE/envs/cryo/lib/pkgconfig"
export OPENSSL_DIR="$MINIFORGE/envs/cryo"

cargo install cryochamber

echo ""
echo "Done! Binaries installed to $CARGO_HOME/bin:"
ls "$CARGO_HOME/bin/cryo"*

echo "Add this to your shell profile to use the tools:"
echo "export PATH=\"$CARGO_HOME/bin:\$PATH\"" >> ~/.bashrc

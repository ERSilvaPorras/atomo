#!/usr/bin/env sh

set -eu

BIN_PATH="$HOME/.local/bin/atomo"
INSTALL_DIR="$HOME/.atomo"

if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    BIN_PATH="/usr/local/bin/atomo"
fi

sudo rm -f "$BIN_PATH"
sudo rm -rf "$INSTALL_DIR"

echo "[OK] Successfully uninstalled Atomo CLI 🚀"

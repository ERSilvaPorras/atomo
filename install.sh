#!/usr/bin/env sh

set -eu

REPO_URL="https://github.com/ERSilvaPorras/atomo.git"
REPO_SSH_URL="git@github.com:ERSilvaPorras/atomo.git"
INSTALL_DIR="$HOME/.atomo"
BIN_PATH="$HOME/.local/bin/atomo"

echo "[INFO] Installing Atomo CLI ..."

if [ ! -d "$INSTALL_DIR" ]; then 
    echo "[INFO] Cloning Atomo repository to $INSTALL_DIR ..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# permissions
chmod +x "$INSTALL_DIR/bin/atomo"

# Verify if ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    BIN_PATH="/usr/local/bin/atomo"
    echo "[INFO] Will create symlink in /usr/local/bin"
fi

# Symlink global
echo "[INFO] Creating symlink ..."
if [ ! -d "$(dirname "$BIN_PATH")" ]; then
    mkdir -p "$(dirname "$BIN_PATH")"
fi

if [ "$BIN_PATH" = "/usr/local/bin/atomo" ]; then
    sudo ln -sf "$INSTALL_DIR/bin/atomo" "$BIN_PATH"
else
    ln -sf "$INSTALL_DIR/bin/atomo" "$BIN_PATH"
fi

echo "[OK] Successfully installed 🚀"

git -C "$INSTALL_DIR" remote set-url origin "$REPO_SSH_URL"
echo "[INFO] Repository URL set to SSH: $REPO_SSH_URL"

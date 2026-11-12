#!/usr/bin/env sh
set -eu

update() {
    echo "[INFO] Updating Atomo CLI ..."

    # check installation
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "[ERROR] Atomo is not installed. Please run install.sh first."
        exit 1
    fi

    # check if it's a git repository
    if [ ! -d "$INSTALL_DIR/.git" ]; then
        echo "[ERROR] Atomo installation is not a git repository. Cannot update."
        exit 1
    fi
        
    echo "[INFO] Pulling latest changes ..."
    . "$SCRIPT_DIR/../lib/commands/sshup.sh"
    sshup "$1"
    git -C "$INSTALL_DIR" pull
    echo "[OK] Successfully updated 🚀"
}

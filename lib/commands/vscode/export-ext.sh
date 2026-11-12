#!/usr/bin/env sh

set -eu

export_ext() {
    EXTENSION_LIST=$(code --list-extensions)


    if [ ! -d "$INSTALL_DIR" ]; then
        git clone "$REPO_BACKUP_URL" "$INSTALL_DIR"
        atomo src "$(basename "$INSTALL_DIR")"
    fi

    if [ ! -d  "$INSTALL_DIR/.git" ]; then
        echo "[ERROR] The directory is not a git repository."
        exit 1
    fi

    echo "$EXTENSION_LIST" > "$EXTENSIONS_FILE_PATH"
    
    . "$SCRIPT_DIR/../lib/helpers/sync-repo.sh"
    sync_repo "$INSTALL_DIR" "$EXTENSIONS_FILE_PATH"
}

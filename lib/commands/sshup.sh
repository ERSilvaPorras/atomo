#!/usr/bin/env sh

set -eu

sshup() {
    NAME_SSH_KEY="${1:-}"

    if [ -z "$NAME_SSH_KEY" ]; then
        echo "[ERROR] Missing key suffix. Usage: atomo sshup <key_suffix>"
        exit 1
    fi

    KEY_PATH="$HOME/.ssh/id_ed25519_$NAME_SSH_KEY"

    if [ ! -f "$KEY_PATH" ]; then
        echo "[ERROR] SSH key not found: $KEY_PATH"
        exit 1
    fi

    KEY_FINGERPRINT=$(ssh-keygen -lf "$KEY_PATH.pub" 2>/dev/null | awk '{print $2}')

    if [ -n "$KEY_FINGERPRINT" ] && ssh-add -l 2>/dev/null | grep -q "$KEY_FINGERPRINT"; then
        return 0
    fi

    if [ -z "${SSH_AUTH_SOCK:-}" ]; then
        eval "$(ssh-agent -s)"
    fi

    ssh-add "$KEY_PATH"
}

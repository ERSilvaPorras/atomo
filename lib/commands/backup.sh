#!/usr/bin/env sh

set -eu

backup() {
    SUB_COMMAND=${1:-}
    shift

    case "$SUB_COMMAND" in
        send)
            . "$SCRIPT_DIR/../lib/commands/backup/tmx.sh"
            backup_tmx "$@"
            ;;
        *)
            echo "Subcommand not found"
            ;;
    esac
}
#!/usr/bin/env sh

set -eu

dev() {
    COMMAND="${1:-}"
    shift

    case "$COMMAND" in
        sync)
            . "$SCRIPT_DIR/../lib/commands/dev/stage.sh"
            dev_stage "$@"
            ;;
        *)
            echo "Command not found"
            ;;
    esac
}
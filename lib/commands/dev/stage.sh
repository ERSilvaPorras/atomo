#!/usr/bin/env sh

dev_stage() {
    local ATOM_DIR="$HOME/.atom"
    
    printf "➜ Verifying the rsync installation...   "
    if ! command -v rsync >/dev/null 2>&1; then
        printf "✖\n"
        exit 1
    fi
    printf "✔\n"
    
    printf "➜ Verifying the Atom installation...   "
    if [ ! -d "$ATOM_DIR" ]; then
        printf "✖\n"
        exit 1
    fi
    printf "✔\n"
    
    printf "➜ Checking for local changes ...   "
    local SRC_DIR="./"
    local DST_DIR="$HOME/.atom"
    local CHANGES
    CHANGES=$(rsync -rlcinh --delete --exclude '.git' "$SRC_DIR" "$DST_DIR" )

    if [ -z "$CHANGES" ]; then
        printf "✖  Everything is up to date. No changes to sync.\n"
        exit 1
    fi
    printf "✔\n"
    
    printf "➜ Synchronizing Changes ...   ✔\n"
    local SYNC_OUTPUT
    SYNC_OUTPUT=$(rsync -rlcih --delete --exclude '.git' "$SRC_DIR" "$DST_DIR" | sed 's/^/    /')
    if [ -n "$SYNC_OUTPUT" ]; then
        printf "%s\n" "$SYNC_OUTPUT"
    fi 
}

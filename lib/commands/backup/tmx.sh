#!/usr/bin/env sh

backup_tmx() {
    SRC_DIR="$1"
    DST_DIR="$2"

    EXT_PATH_PATTERN="^[[:alnum:]_-]+@[[:alnum:]._-]+:/.*$"

    
    if [ -z "$SRC_DIR" ] || [ ! -d "$SRC_DIR" ]; then
        printf "➜ Checking if the source folder exists ✖\n"
        exit 1
    fi

    if [ -z "$DST_DIR" ]; then
        printf "➜ Checking whether I specified the destination folder:   ✖\n"
        return 1
    fi
    
    printf "➜ Analyzing the type of destination folder path:   "
    if printf '%s\n' "$DST_DIR" | grep -Eq "$EXT_PATH_PATTERN"; then
        printf "[EXTERNAL]\n"
        result=$(rsync -aiuh --exclude ".git" --exclude ".venv" "$SRC_DIR" "$DST_DIR" 2>&1)
        if [ $? != 0 ]; then
            printf "Error en el respaldo (código: %d) ✖\n" "$result"
            return 1
        fi
        printf "%s\n" "$result"
        return 0
    fi
    printf "[INTERNAL]\n"
    
    if [ ! -d "$DST_DIR" ]; then
        printf "➜ Checking if the destination folder exists:   ✖\n"
        exit 1
    fi

    rsync -aiuh --exclude ".git" --exclude ".venv" "$SRC_DIR" "$DST_DIR" 2>&1
}

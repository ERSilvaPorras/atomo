#!/usr/bin/env sh

set -eu


scr() {
    NAME_REPO=${1:-}
    REPO_DIR="$HOME/Documents/git/$NAME_REPO"
    
    if [ -z "$NAME_REPO" ]; then
        REPO_DIR="."
    fi

    if [ "$NAME_REPO" = "atomo" ]; then
        REPO_DIR="$HOME/.atomo"
    fi

    git -C "$REPO_DIR" config --local user.name "ERSilvaPorras"
    git -C "$REPO_DIR" config --local user.email "eduasilvaporras@frba.utn.edu.ar"
    
    printf "\t[OK] Repository ${REPO_DIR} configured successfully ✅\n"
}

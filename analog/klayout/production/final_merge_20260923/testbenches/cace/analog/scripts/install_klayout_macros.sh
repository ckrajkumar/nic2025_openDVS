#!/bin/bash
# Symlink the project's KLayout macros into ~/.klayout/pymacros so they
# load in every KLayout session (menu entries defined in each .lym).
# Idempotent: re-running just refreshes the symlinks.
# Restart KLayout (or reload in the Macro IDE, F5) after installing.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC_DIR="$REPO_ROOT/analog/klayout/pymacros"
DST_DIR="$HOME/.klayout/pymacros"

mkdir -p "$DST_DIR"

for macro in "$SRC_DIR"/*.lym; do
    name="$(basename "$macro")"
    dst="$DST_DIR/$name"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "Backing up existing $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sfn "$macro" "$dst"
    echo "Installed: $dst -> $macro"
done

#!/usr/bin/env bash
#
# install.sh
#
# Symlinks everything under ./home into your actual $HOME, mirroring the
# same relative paths. Run this from inside your cloned dotfiles repo.
# Existing real files are backed up (not overwritten) with a .bak suffix.
#
# Usage:
#   ./install.sh

set -uo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/home" && pwd)"

if [ ! -d "$SRC" ]; then
    echo "No ./home directory found next to this script. Run from repo root."
    exit 1
fi

echo "Linking dotfiles from $SRC into $HOME"
echo "----------------------------------------"

find "$SRC" -type f -o -type l | while read -r file; do
    rel="${file#"$SRC"/}"
    dest="$HOME/$rel"
    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "$dest.bak"
        echo "  [backup] $rel -> $rel.bak"
    fi

    ln -sfn "$file" "$dest"
    echo "  [link]   $rel"
done

echo ""
echo "Done. Restart the relevant apps (or your session) to pick up changes."
echo "Note: pywal wallpaper switching still needs the 'wal' package installed"
echo "(pip install pywal or your distro package) for colors-kitty.conf etc."
echo "to regenerate on wallpaper change."

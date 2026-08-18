#!/usr/bin/env bash
#
# collect-dotfiles.sh
#
# Gathers config files for a KDE/i3/polybar/rofi/kitty/spicetify/pywal
# rice setup into a single folder structured for a git repo, using
# relative paths so the layout mirrors $HOME exactly. Nothing is deleted
# or moved from your system - everything is COPIED.
#
# Usage:
#   chmod +x collect-dotfiles.sh
#   ./collect-dotfiles.sh [target-dir]
#
# Default target-dir is ~/dotfiles-rice

set -uo pipefail

TARGET="${1:-$HOME/dotfiles-rice}"
LOG="$TARGET/.collect-log.txt"

mkdir -p "$TARGET"
: > "$LOG"

echo "Collecting rice dotfiles into: $TARGET"
echo "----------------------------------------"

# ---- helper: copy a file or dir, preserving its path relative to $HOME ----
grab() {
    local src="$1"
    if [ -e "$src" ] || [ -L "$src" ]; then
        local rel="${src#"$HOME"/}"
        local dest="$TARGET/home/$rel"
        mkdir -p "$(dirname "$dest")"
        cp -aL "$src" "$dest" 2>>"$LOG"
        echo "  [OK]   $rel"
    else
        echo "  [miss] ${src#"$HOME"/}"
    fi
}

section() {
    echo ""
    echo ">>> $1"
}

# =========================================================
# KDE Plasma / Kubuntu desktop
# =========================================================
section "KDE Plasma"
grab "$HOME/.config/kdeglobals"
grab "$HOME/.config/kwinrc"
grab "$HOME/.config/kwinrulesrc"
grab "$HOME/.config/plasmarc"
grab "$HOME/.config/plasmashellrc"
grab "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
grab "$HOME/.config/kscreenlockerrc"
grab "$HOME/.config/kglobalshortcutsrc"
grab "$HOME/.config/khotkeysrc"
grab "$HOME/.config/kwinoutputconfig.json"
grab "$HOME/.config/breezerc"
grab "$HOME/.config/gtkrc"
grab "$HOME/.config/gtkrc-2.0"
grab "$HOME/.config/gtk-3.0/settings.ini"
grab "$HOME/.config/gtk-4.0/settings.ini"
grab "$HOME/.config/Kvantum"
grab "$HOME/.local/share/plasma"
grab "$HOME/.local/share/color-schemes"
grab "$HOME/.local/share/plasma_looknfeel"
grab "$HOME/.local/share/aurorae"
grab "$HOME/.icons/default"

# =========================================================
# Dolphin
# =========================================================
section "Dolphin"
grab "$HOME/.config/dolphinrc"
grab "$HOME/.local/share/dolphin"
grab "$HOME/.local/share/kxmlgui5/dolphin"
grab "$HOME/.local/share/kservices5/ServiceMenus"

# =========================================================
# Spicetify
# =========================================================
section "Spicetify"
grab "$HOME/.config/spicetify"

# =========================================================
# i3
# =========================================================
section "i3"
grab "$HOME/.config/i3"
grab "$HOME/.i3"

# =========================================================
# polybar
# =========================================================
section "polybar"
grab "$HOME/.config/polybar"

# =========================================================
# rofi
# =========================================================
section "rofi"
grab "$HOME/.config/rofi"

# =========================================================
# kitty
# =========================================================
section "kitty"
grab "$HOME/.config/kitty"

# =========================================================
# pywal (colors + templates; NOT the cache of every past wallpaper)
# =========================================================
section "pywal"
grab "$HOME/.config/wal"
# Only grab the current active cache state, not the whole history,
# since ~/.cache/wal can balloon with every wallpaper you've ever used.
mkdir -p "$TARGET/home/.cache/wal"
for f in colors colors.json colors.sh colors.css colors-kitty.conf \
         colors-rofi-dark.rasi colors-rofi-light.rasi colors-polybar.ini \
         wal wallpaper; do
    [ -e "$HOME/.cache/wal/$f" ] && cp -aL "$HOME/.cache/wal/$f" "$TARGET/home/.cache/wal/" 2>>"$LOG"
done
echo "  [OK]   .cache/wal (current state only)"

# =========================================================
# Custom scripts (wallpaper switcher, pywal automation, etc.)
# Common locations - grabbed wholesale since these are usually small.
# =========================================================
section "Custom scripts"
grab "$HOME/.local/bin"
grab "$HOME/bin"
grab "$HOME/scripts"
grab "$HOME/.scripts"

# Also search i3 and polybar configs for any script paths they reference
# (e.g. "exec ~/.config/i3/scripts/wal-random.sh") so you don't miss one
# living somewhere non-standard.
section "Scanning i3/polybar configs for referenced scripts"
if [ -d "$HOME/.config/i3" ] || [ -d "$HOME/.config/polybar" ]; then
    grep -rhoE '(~|\$HOME)(/[A-Za-z0-9_.\-]+)+\.(sh|py)' \
        "$HOME/.config/i3" "$HOME/.config/polybar" 2>/dev/null | sort -u | \
    while read -r p; do
        expanded="${p/#\~/$HOME}"
        expanded="${expanded/#\$HOME/$HOME}"
        grab "$expanded"
    done
fi

# =========================================================
# Shell + startup glue (often what wires everything together)
# =========================================================
section "Shell / session glue"
grab "$HOME/.xinitrc"
grab "$HOME/.xprofile"
grab "$HOME/.Xresources"
grab "$HOME/.bashrc"
grab "$HOME/.zshrc"
grab "$HOME/.config/environment.d"
grab "$HOME/.config/autostart"

echo ""
echo "----------------------------------------"
echo "Done. Files copied under: $TARGET/home"
echo "Anything marked [miss] just means that app/file isn't on this machine -"
echo "safe to ignore if you don't use it."
echo "Full stderr log (if any): $LOG"

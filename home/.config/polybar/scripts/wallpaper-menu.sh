#!/usr/bin/env bash
# Rofi wallpaper picker with thumbnail previews.

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

menu() {
    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        [ -e "$img" ] || continue
        name=$(basename "$img")
        echo -en "${name}\x00icon\x1f${img}\n"
    done
}

chosen=$(menu | rofi -dmenu -i -p "Wallpaper" -show-icons -theme-str 'window {width: 60%; height: 60%;} listview {columns: 3; lines: 3;} element-icon {size: 220px;}')

[ -z "$chosen" ] && exit 0

feh-wal "$WALLPAPER_DIR/$chosen"

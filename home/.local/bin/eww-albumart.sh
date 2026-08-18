#!/usr/bin/env bash
CACHE="/tmp/eww-albumart.png"
RAW="/tmp/eww-albumart-raw.png"
BLANK="/home/garrett/.local/share/eww-blank-art.png"

art_url=$(playerctl --player=spotify metadata mpris:artUrl 2>/dev/null)

if [ -z "$art_url" ]; then
    echo "$BLANK"
    exit 0
fi

if [[ "$art_url" == file://* ]]; then
    cp "${art_url#file://}" "$RAW" 2>/dev/null
else
    curl -s -o "$RAW" "$art_url" --max-time 5
fi

if [ -s "$RAW" ]; then
    convert "$RAW" -resize 15% -filter point -resize 500% "$CACHE" 2>/dev/null
    echo "$CACHE"
else
    echo "$BLANK"
fi

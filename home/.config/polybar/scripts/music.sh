#!/usr/bin/env bash
WIDTH=30
STATE_DIR="/tmp/.polybar_music_scroll"
TEXT_FILE="$STATE_DIR/text"
OFFSET_FILE="$STATE_DIR/offset"

mkdir -p "$STATE_DIR"

if ! command -v playerctl &>/dev/null; then
    echo "playerctl not found"
    exit 0
fi

status=$(playerctl status 2>/dev/null)

if [ -z "$status" ]; then
    echo ""
    exit 0
fi

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

icon=""
[ "$status" = "Playing" ] && icon=""

if [ -n "$artist" ]; then
    text="$icon $artist - $title"
else
    text="$icon $title"
fi

if [ "${#text}" -le "$WIDTH" ]; then
    echo "$text"
    rm -f "$TEXT_FILE" "$OFFSET_FILE"
    exit 0
fi

scroll_text="${text}          "
full_len=${#scroll_text}

prev_text=$(cat "$TEXT_FILE" 2>/dev/null)
offset=$(cat "$OFFSET_FILE" 2>/dev/null || echo 0)

if [ "$prev_text" != "$text" ]; then
    offset=0
    echo "$text" > "$TEXT_FILE"
fi

looped="${scroll_text}${scroll_text}"
window="${looped:$offset:$WIDTH}"
echo "$window"

offset=$(( (offset + 1) % full_len ))
echo "$offset" > "$OFFSET_FILE"

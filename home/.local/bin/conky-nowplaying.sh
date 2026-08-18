#!/usr/bin/env bash
WIDTH=28
STATE_DIR="/tmp/.eww_nowplaying_scroll"
TEXT_FILE="$STATE_DIR/text"
OFFSET_FILE="$STATE_DIR/offset"
mkdir -p "$STATE_DIR"

if ! playerctl --player=spotify status &>/dev/null; then
    echo "Not playing"
    rm -f "$TEXT_FILE" "$OFFSET_FILE"
    exit 0
fi

artist=$(playerctl --player=spotify metadata artist 2>/dev/null)
title=$(playerctl --player=spotify metadata title 2>/dev/null)
text="${artist} - ${title}"

if [ "${#text}" -le "$WIDTH" ]; then
    printf "%-${WIDTH}s" "$text"
    rm -f "$TEXT_FILE" "$OFFSET_FILE"
    exit 0
fi

scroll_text="${text}     "
full_len=${#scroll_text}

prev_text=$(cat "$TEXT_FILE" 2>/dev/null)
offset=$(cat "$OFFSET_FILE" 2>/dev/null || echo 0)

if [ "$prev_text" != "$text" ]; then
    offset=0
    echo "$text" > "$TEXT_FILE"
fi

looped="${scroll_text}${scroll_text}"
window="${looped:$offset:$WIDTH}"
printf "%-${WIDTH}s" "$window"

offset=$(( (offset + 1) % full_len ))
echo "$offset" > "$OFFSET_FILE"

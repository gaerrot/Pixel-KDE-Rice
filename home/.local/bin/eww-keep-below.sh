#!/usr/bin/env bash
# Listens for i3 window events and re-lowers the eww widget below
# every newly opened window, working around i3's lack of native
# support for keeping desktop-type windows always at the bottom.

i3-msg -t subscribe -m '["window"]' | while read -r line; do
    change=$(echo "$line" | python3 -c "import json,sys; print(json.load(sys.stdin).get('change',''))" 2>/dev/null)
    if [ "$change" = "new" ]; then
        wid=$(xdotool search --class "Eww" 2>/dev/null | head -1)
        if [ -n "$wid" ]; then
            xdotool windowlower "$wid" 2>/dev/null
        fi
    fi
done

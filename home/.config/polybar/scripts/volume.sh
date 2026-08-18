#!/usr/bin/env bash
raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)

if [ -z "$raw" ]; then
    echo "no sink"
    exit 0
fi

if echo "$raw" | grep -q "MUTED"; then
    echo " muted"
    exit 0
fi

pct=$(echo "$raw" | awk '{printf "%d", $2 * 100}')

if [ "$pct" -eq 0 ]; then
    icon=""
elif [ "$pct" -lt 50 ]; then
    icon=""
else
    icon=""
fi

echo "$icon ${pct}%"

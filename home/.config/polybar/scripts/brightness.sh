#!/usr/bin/env bash
if ! command -v brightnessctl &>/dev/null; then
    echo "no brightnessctl"
    exit 0
fi

current=$(brightnessctl get 2>/dev/null)
max=$(brightnessctl max 2>/dev/null)

if [ -z "$current" ] || [ -z "$max" ] || [ "$max" -eq 0 ]; then
    echo "n/a"
    exit 0
fi

pct=$(( (current * 100 + max / 2) / max ))

if [ "$1" = "up" ]; then
    newpct=$(( (pct / 5) * 5 + 5 ))
    [ "$newpct" -gt 100 ] && newpct=100
    brightnessctl set "${newpct}%" >/dev/null
    exit 0
fi

if [ "$1" = "down" ]; then
    newpct=$(( ((pct - 1) / 5) * 5 ))
    [ "$newpct" -lt 0 ] && newpct=0
    brightnessctl set "${newpct}%" >/dev/null
    exit 0
fi

echo " ${pct}%"

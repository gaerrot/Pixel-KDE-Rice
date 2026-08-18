#!/usr/bin/env bash
WIDTH=27
raw=$(curl -s "wttr.in?format=%l|%C|%t" --max-time 5)
if [ -z "$raw" ]; then
    printf "%-${WIDTH}.${WIDTH}s\n" "Unavailable"
    exit 0
fi
location=$(echo "$raw" | cut -d'|' -f1)
condition=$(echo "$raw" | cut -d'|' -f2)
temp=$(echo "$raw" | cut -d'|' -f3)
icon=$(python3 /home/garrett/.local/bin/weather_icon.py "$condition")
text="$icon $location: $condition $temp"
printf "%-${WIDTH}.${WIDTH}s\n" "$text"

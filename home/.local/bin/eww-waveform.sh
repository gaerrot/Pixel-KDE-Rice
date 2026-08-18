#!/usr/bin/env bash
stdbuf -oL cava -p /home/garrett/.config/cava-eww/config | while read -r line; do
    line="${line%;}"
    IFS=';' read -ra vals <<< "$line"
    json="["
    for i in "${!vals[@]}"; do
        json+="${vals[$i]}"
        if [ "$i" -lt $((${#vals[@]}-1)) ]; then json+=","; fi
    done
    json+="]"
    echo "$json"
done

#!/usr/bin/env bash
# Solid-color lock screen using the current pywal background color.

if [ -f ~/.cache/wal/colors.sh ]; then
    source ~/.cache/wal/colors.sh
    bg="${background#\#}"
else
    bg="1d1a17"
fi

i3lock -c "$bg"

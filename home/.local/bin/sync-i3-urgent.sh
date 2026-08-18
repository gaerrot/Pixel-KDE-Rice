#!/usr/bin/env bash
. /home/garrett/.cache/wal/colors.sh
/usr/bin/python3 /home/garrett/.local/bin/i3_urgent.py "$color3"
i3-msg reload

#!/usr/bin/env bash
exec 200>/tmp/polybar-launch.lock
flock -n 200 || exit 0

if pgrep -u "$UID" -x polybar >/dev/null; then
    polybar-msg cmd restart >/dev/null 2>&1
    echo "Restarted via IPC"
else
    polybar bar 2>&1 | tee -a /tmp/polybar1.log & disown
    echo "Bars launched fresh"
fi

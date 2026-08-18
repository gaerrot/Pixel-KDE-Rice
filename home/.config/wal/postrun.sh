#!/usr/bin/env bash
~/.config/polybar/launch.sh
/home/garrett/.local/bin/sync-qt5ct-highlight.sh >> /tmp/pywal-sync.log 2>&1
/home/garrett/.local/bin/sync-kde-accent.sh >> /tmp/pywal-sync.log 2>&1

#!/usr/bin/env bash
options="  Lock\n  Logout\n  Reboot\n  Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" -theme-str 'listview {lines: 4;}')

case "$chosen" in
    *Lock*)
        i3lock
        ;;
    *Logout*)
        i3-msg exit
        ;;
    *Reboot*)
        systemctl reboot
        ;;
    *Shutdown*)
        systemctl poweroff
        ;;
esac

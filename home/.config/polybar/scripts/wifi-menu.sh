#!/usr/bin/env bash

networks=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list --rescan no | awk -F':' '!seen[$1]++ && $1 != "" {printf "%-30s %s%%  %s\n", $1, $2, ($3=="" ? "open" : $3)}')

chosen=$(echo "$networks" | rofi -dmenu -i -p "WiFi" -theme-str 'listview {lines: 8;}')

[ -z "$chosen" ] && exit 0

ssid=$(echo "$chosen" | awk '{print $1}')

if nmcli -t -f NAME connection show | grep -qx "$ssid"; then
    nmcli connection up "$ssid"
else
    password=$(rofi -dmenu -p "Password for $ssid" -password)
    [ -z "$password" ] && exit 0
    nmcli device wifi connect "$ssid" password "$password"
fi

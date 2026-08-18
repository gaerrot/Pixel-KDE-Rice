#!/usr/bin/env bash
# Rofi-based Bluetooth device picker.

scan_option="Scan for new devices (10s)"

build_menu() {
    paired=$(bluetoothctl devices Paired | while read -r _ mac name; do
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            echo "$name [connected]  ($mac)"
        else
            echo "$name  ($mac)"
        fi
    done)
    echo -e "${scan_option}\n${paired}"
}

chosen=$(build_menu | rofi -dmenu -i -p "Bluetooth" -theme-str 'listview {lines: 8;}')

[ -z "$chosen" ] && exit 0

if [ "$chosen" = "$scan_option" ]; then
    bluetoothctl --timeout 10 scan on
    new_devices=$(bluetoothctl devices | while read -r _ mac name; do
        if ! bluetoothctl info "$mac" | grep -q "Paired: yes"; then
            echo "$name  ($mac)"
        fi
    done)

    if [ -z "$new_devices" ]; then
        notify-send "Bluetooth" "No new devices found." 2>/dev/null
        exit 0
    fi

    pick=$(echo "$new_devices" | rofi -dmenu -i -p "Pair with" -theme-str 'listview {lines: 6;}')
    [ -z "$pick" ] && exit 0
    mac=$(echo "$pick" | grep -oP '\(\K[^)]+')
    bluetoothctl pair "$mac"
    bluetoothctl trust "$mac"
    bluetoothctl connect "$mac"
    exit 0
fi

mac=$(echo "$chosen" | grep -oP '\(\K[^)]+')

if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$mac"
else
    bluetoothctl connect "$mac"
fi

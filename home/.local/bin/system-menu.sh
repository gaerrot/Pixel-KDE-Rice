#!/usr/bin/env bash
options="Brightness Up\nBrightness Down\nBluetooth Toggle\nBluetooth Devices"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "System" -theme-str 'window {location: north east; anchor: north east; x-offset: 20px; y-offset: 55px; width: 300px;} listview {scrollbar: false;}')

case "$chosen" in
    "Brightness Up")
        ~/.config/polybar/scripts/brightness.sh up
        ;;
    "Brightness Down")
        ~/.config/polybar/scripts/brightness.sh down
        ;;
    "Bluetooth Toggle")
        ~/.config/polybar/scripts/bluetooth.sh toggle
        ;;
    "Bluetooth Devices")
        ~/.config/polybar/scripts/bluetooth-menu.sh
        ;;
esac

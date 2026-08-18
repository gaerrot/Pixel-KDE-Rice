#!/usr/bin/env bash
if [ "$1" = "toggle" ]; then
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi
    exit 0
fi

if ! command -v bluetoothctl &>/dev/null; then
    echo "no bluez"
    exit 0
fi

if bluetoothctl show | grep -q "Powered: yes"; then
    connected=$(bluetoothctl devices Connected | wc -l)
    if [ "$connected" -gt 0 ]; then
        name=$(bluetoothctl devices Connected | head -n1 | cut -d' ' -f3-)
        echo " $name"
    else
        echo " on"
    fi
else
    echo " off"
fi

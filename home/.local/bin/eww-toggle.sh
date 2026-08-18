#!/usr/bin/env bash
if eww active-windows | grep -q "main"; then
    eww close main
else
    eww open main
fi

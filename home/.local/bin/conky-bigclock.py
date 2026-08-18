#!/usr/bin/env python3
import datetime

DIGITS = {
    '0': ["█████", "██ ██", "██ ██", "██ ██", "█████"],
    '1': ["  ██ ", " ███ ", "  ██ ", "  ██ ", "██████"],
    '2': ["█████", "   ██", "█████", "██   ", "██████"],
    '3': ["█████", "   ██", "█████", "   ██", "█████"],
    '4': ["██ ██", "██ ██", "██████", "   ██", "   ██"],
    '5': ["██████", "██   ", "█████", "   ██", "█████"],
    '6': ["█████", "██   ", "█████", "██ ██", "█████"],
    '7': ["██████", "   ██", "  ██ ", " ██  ", " ██  "],
    '8': ["█████", "██ ██", "█████", "██ ██", "█████"],
    '9': ["█████", "██ ██", "█████", "   ██", "█████"],
}

now = datetime.datetime.now()
sec = now.second
colon = "██" if sec % 2 == 0 else "  "
colon_pattern = [" ", colon.strip() or " ", " ", colon.strip() or " ", " "]

hh = now.strftime("%H")
mm = now.strftime("%M")

rows = ["" for _ in range(5)]
for ch in hh:
    for i in range(5):
        rows[i] += DIGITS[ch][i] + " "
for i in range(5):
    rows[i] += colon_pattern[i] + " "
for ch in mm:
    for i in range(5):
        rows[i] += DIGITS[ch][i] + " "

width = max(len(r) for r in rows)
rows = [r.ljust(width) for r in rows]

print("┌" + "─" * (width + 2) + "┐")
for r in rows:
    print("│ " + r + " │")
print("└" + "─" * (width + 2) + "┘")

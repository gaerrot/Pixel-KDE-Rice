#!/usr/bin/env python3
import subprocess, sys, os

CAVA_BARS = 64
CAVA_MAX_RANGE = 30
BAR_WIDTH = 3
GAP = 1
MIN_ROWS, MAX_ROWS = 4, 30
MIN_BARS, MAX_BARS = 4, CAVA_BARS

def load_accent_color():
    hex_color = "893C4F"
    try:
        with open(os.path.expanduser("~/.cache/wal/colors.sh")) as f:
            for line in f:
                if line.startswith("color3="):
                    hex_color = line.split("=")[1].strip().strip("'\"").lstrip("#")
                    break
    except Exception:
        pass
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    return f"\033[38;2;{r};{g};{b}m"

LIT = load_accent_color()
DIM = "\033[38;2;30;30;30m"
RESET = "\033[0m"
HIDE_CURSOR = "\033[?25l"
SHOW_CURSOR = "\033[?25h"

BLOCK = "█" * BAR_WIDTH

def get_dims():
    size = os.get_terminal_size(sys.stdout.fileno())
    rows = max(MIN_ROWS, min(MAX_ROWS, size.lines // 2))
    bars = max(MIN_BARS, min(MAX_BARS, size.columns // (BAR_WIDTH + GAP)))
    return rows, bars

def render(levels, rows, bars):
    gridline = DIM + ("─" * BAR_WIDTH + " " * GAP) * bars + RESET
    lines = []
    for row in range(rows, 0, -1):
        cells = []
        for lvl in levels:
            cells.append((LIT if lvl >= row else DIM) + BLOCK + RESET)
        lines.append((" " * GAP).join(cells))
        lines.append(gridline)
    return "\n".join(lines)

def main():
    config_path = os.path.expanduser("~/.config/cava/config")
    proc = subprocess.Popen(["stdbuf", "-oL", "cava", "-p", config_path], stdout=subprocess.PIPE, text=True)
    last_dims = None
    sys.stdout.write(HIDE_CURSOR)
    try:
        for line in proc.stdout:
            line = line.strip().rstrip(";")
            if not line:
                continue
            parts = [p for p in line.split(";") if p != ""]
            try:
                raw_levels = [int(p) for p in parts]
            except ValueError:
                continue
            if len(raw_levels) < CAVA_BARS:
                continue
            raw_levels = raw_levels[:CAVA_BARS]

            rows, bars = get_dims()
            if (rows, bars) != last_dims:
                sys.stdout.write("\033[2J")
                last_dims = (rows, bars)

            indices = [int(i * CAVA_BARS / bars) for i in range(bars)]
            selected = [raw_levels[i] for i in indices]
            scaled = [round(v * rows / CAVA_MAX_RANGE) for v in selected]

            sys.stdout.write("\033[H")
            sys.stdout.write(render(scaled, rows, bars) + "\n")
            sys.stdout.flush()
    except KeyboardInterrupt:
        pass
    finally:
        sys.stdout.write(SHOW_CURSOR)
        sys.stdout.flush()
        proc.terminate()

if __name__ == "__main__":
    main()

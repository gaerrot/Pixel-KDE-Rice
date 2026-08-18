import sys
path = "/home/garrett/.config/kdeglobals"
hex_color = sys.argv[1].lstrip("#")
r = int(hex_color[0:2], 16)
g = int(hex_color[2:4], 16)
b = int(hex_color[4:6], 16)
new_rgb = f"{r},{g},{b}"

with open(path) as f:
    lines = f.readlines()

section = None
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith("["):
        section = stripped
        continue
    if stripped.startswith("DecorationFocus=") or stripped.startswith("DecorationHover="):
        key = stripped.split("=")[0]
        lines[i] = f"{key}={new_rgb}\n"
    elif section == "[Colors:Selection]" and stripped.startswith("BackgroundNormal="):
        lines[i] = f"BackgroundNormal={new_rgb}\n"

with open(path, "w") as f:
    f.writelines(lines)

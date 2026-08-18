import sys
path = "/home/garrett/.config/qt5ct/colors/pywal.conf"
hex_color = sys.argv[1].lstrip("#")
new_color = f"#ff{hex_color}"

with open(path) as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if line.startswith("active_colors=") or line.startswith("inactive_colors="):
        key, _, rest = line.partition("=")
        values = [v.strip() for v in rest.strip().split(",")]
        values[12] = new_color
        lines[i] = f"{key}={', '.join(values)}\n"

with open(path, "w") as f:
    f.writelines(lines)

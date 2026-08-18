import sys
path = "/home/garrett/.config/i3/config"
hex_color = sys.argv[1]

with open(path) as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if line.strip().startswith("client.urgent"):
        lines[i] = f"client.urgent #000000 {hex_color} #ffffff #000000 #000000\n"
        break

with open(path, "w") as f:
    f.writelines(lines)

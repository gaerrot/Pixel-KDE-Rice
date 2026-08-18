import sys
path = "/home/garrett/.config/gtk-3.0/gtk.css"
accent = sys.argv[1]

content = f"""@define-color theme_selected_bg_color_breeze {accent};
@define-color theme_hovering_selected_bg_color_breeze {accent};
@define-color theme_unfocused_selected_bg_color_alt_breeze {accent};
@define-color theme_unfocused_selected_bg_color_breeze alpha({accent}, 0.5);
@define-color insensitive_selected_bg_color_breeze alpha({accent}, 0.35);
"""

with open(path, "w") as f:
    f.write(content)

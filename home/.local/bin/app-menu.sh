#!/usr/bin/env bash
CATS_FILE="$HOME/.config/rofi/categories.txt"
FAVS_FILE="$HOME/.config/rofi/favorites.txt"
touch "$CATS_FILE" "$FAVS_FILE"

ROFI_POS=""
if [ "$APP_MENU_DROPDOWN" = "1" ]; then
    ROFI_POS="-theme-str 'window {location: north east; anchor: north east; x-offset: 20px; y-offset: 55px; width: 380px;}'"
fi

get_all_apps() {
    awk '
        FNR == 1 {
            if (n != "") flush()
            base = FILENAME
            sub(/.*\//, "", base)
            if (base in seen) { skip = 1 } else { skip = 0; seen[base] = 1 }
            n = ""; e = ""; nd = ""; ty = ""
        }
        skip { next }
        /^Name=/  && n  == "" { n  = substr($0, 6) }
        /^Exec=/  && e  == "" { e  = substr($0, 6) }
        /^NoDisplay=/ && nd == "" { nd = substr($0, 11) }
        /^Type=/  && ty == "" { ty = substr($0, 6) }
        function flush() {
            if (n != "" && e != "" && nd != "true" && ty == "Application") {
                gsub(/%[a-zA-Z]/, "", e)
                print n "\t" e
            }
        }
        END { flush() }
    ' \
        "$HOME/.local/share/applications"/*.desktop \
        /usr/local/share/applications/*.desktop \
        /usr/share/applications/*.desktop \
        /var/lib/snapd/desktop/applications/*.desktop \
        /var/lib/flatpak/exports/share/applications/*.desktop \
        "$HOME/.local/share/flatpak/exports/share/applications"/*.desktop \
        2>/dev/null
}

toggle_favorite() {
    if grep -qxF "$1" "$FAVS_FILE"; then
        grep -vxF "$1" "$FAVS_FILE" > "$FAVS_FILE.tmp" && mv "$FAVS_FILE.tmp" "$FAVS_FILE"
    else
        echo "$1" >> "$FAVS_FILE"
    fi
}

launch_app() {
    setsid -f bash -c "$1" >/dev/null 2>&1
}

star_names() {
    awk -v favfile="$FAVS_FILE" '
        BEGIN { while ((getline line < favfile) > 0) fav[line] = 1 }
        { if ($0 in fav) print "★ " $0; else print $0 }
    '
}

show_app_list() {
    local priority_names="$1"
    local all_apps="$2"
    local header="$3"

    while true; do
        priority_display=$(echo "$all_apps" | awk -F'\t' -v prio="$priority_names" '
            BEGIN { n = split(prio, arr, "\n"); for (i=1;i<=n;i++) if (arr[i] != "") order[arr[i]] = i }
            $1 in order { lines[order[$1]] = $1 }
            END { for (i=1;i<=n;i++) if (i in lines) print lines[i] }
        ')

        rest_display=$(echo "$all_apps" | awk -F'\t' -v prio="$priority_names" '
            BEGIN { n = split(prio, arr, "\n"); for (i=1;i<=n;i++) if (arr[i] != "") skip[arr[i]] = 1 }
            !($1 in skip) { print $1 }
        ' | sort)

        if [ -n "$priority_display" ] && [ -n "$rest_display" ]; then
            display=$( { echo "$priority_display"; echo "────────────"; echo "$rest_display"; } | star_names)
        else
            display=$( { echo "$priority_display"; echo "$rest_display"; } | sed '/^$/d' | star_names)
        fi

        chosen=$(echo "$display" | eval rofi -dmenu -i -p \"\$header\" $ROFI_POS)
        rc=$?

        clean_name=$(echo "$chosen" | sed 's/^★ //')
        [ -z "$clean_name" ] && return 1

        exec_cmd=$(echo "$all_apps" | awk -F'\t' -v n="$clean_name" '$1 == n {print $2; exit}')

        if [ "$rc" -eq 10 ]; then
            toggle_favorite "$clean_name"
            continue
        else
            if [ -n "$exec_cmd" ]; then
                launch_app "$exec_cmd"
                exit 0
            fi
            return 1
        fi
    done
}

all_apps=$(get_all_apps)
selected_row=""

while true; do
    categories=$(cut -d'|' -f1 "$CATS_FILE" | sort -u)
    app_names=$(echo "$all_apps" | cut -f1 | sort)

    menu_display=$(
        echo -e "★ Favorites\n${categories}\n────────────"
        echo "$app_names" | star_names
    )

    if [ -n "$selected_row" ]; then
        selection_raw=$(echo "$menu_display" | eval rofi -dmenu -i -p \"Launch\" -theme-str \'listview { scrollbar: false\; }\' $ROFI_POS -selected-row \"\$selected_row\")
    else
        selection_raw=$(echo "$menu_display" | eval rofi -dmenu -i -p \"Launch\" -theme-str \'listview { scrollbar: false\; }\' $ROFI_POS)
    fi
    rc=$?
    selection=$(echo "$selection_raw" | sed 's/^★ //')
    selected_row=""

    if [ "$selection_raw" = "★ Favorites" ]; then
        favs=$(cat "$FAVS_FILE")
        show_app_list "$favs" "$all_apps" "Favorites"
    elif echo "$categories" | grep -qxF "$selection"; then
        names=$(awk -F'|' -v cat="$selection" '$1 == cat {print $2}' "$CATS_FILE")
        show_app_list "$names" "$all_apps" "$selection"
    elif [ -z "$selection" ]; then
        exit 0
    elif [ "$rc" -eq 10 ]; then
        toggle_favorite "$selection"
        new_display=$(
            echo -e "★ Favorites\n${categories}\n────────────"
            echo "$app_names" | star_names
        )
        row_num=$(echo "$new_display" | grep -nF "$selection" | head -1 | cut -d: -f1)
        selected_row=$((row_num - 1))
    else
        exec_cmd=$(echo "$all_apps" | awk -F'\t' -v n="$selection" '$1 == n {print $2; exit}')
        if [ -n "$exec_cmd" ]; then
            launch_app "$exec_cmd"
            exit 0
        fi
    fi
done

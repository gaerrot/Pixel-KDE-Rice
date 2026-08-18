#!/usr/bin/env bash
WIDTH=19

pad() {
    printf "%-${WIDTH}.${WIDTH}s\n" "$1"
}

while true; do
    if ! playerctl --player=spotify status &>/dev/null; then
        pad "Not playing"
        sleep 1
        continue
    fi

    artist=$(playerctl --player=spotify metadata artist 2>/dev/null)
    title=$(playerctl --player=spotify metadata title 2>/dev/null)
    text="$artist - $title"

    if [ "${#text}" -le "$WIDTH" ]; then
        pad "$text"
        sleep 0.3
        continue
    fi

    scroll_text="${text}     "
    full_len=${#scroll_text}
    looped="${scroll_text}${scroll_text}"

    offset=0
    while [ "$offset" -lt "$full_len" ]; do
        current_artist=$(playerctl --player=spotify metadata artist 2>/dev/null)
        current_title=$(playerctl --player=spotify metadata title 2>/dev/null)
        if [ "$current_artist - $current_title" != "$text" ]; then
            break
        fi
        window="${looped:$offset:$WIDTH}"
        pad "$window"
        offset=$((offset + 1))
        sleep 0.25
    done
done

#!/usr/bin/env bash
. /home/garrett/.cache/wal/colors.sh

cat > /home/garrett/.config/eww/eww.scss << CSS
* {
    all: unset;
    font-family: "Departure Mono", "Symbols Nerd Font Mono";
}

.outer {
    padding: 4px;
}

.bubble {
    background-color: ${background};
    border-radius: 18px;
    padding: 22px;
    border: 2px solid ${color3};
}

.clock-bubble {
    padding-top: 0px;
}

.accent-line {
    min-height: 4px;
    background-color: ${color3};
    border-radius: 4px 4px 0px 0px;
    margin-bottom: 18px;
}

.clock-label {
    font-size: 10px;
    color: ${color5};
    letter-spacing: 3px;
    margin-bottom: 2px;
}

.clock {
    font-size: 64px;
    font-weight: bold;
    color: ${color3};
}

.date {
    font-size: 15px;
    color: ${foreground};
    margin-top: 6px;
}

.section-title {
    font-size: 12px;
    color: ${color3};
    letter-spacing: 2px;
    margin-bottom: 4px;
}

.weather-value {
    font-size: 15px;
    color: ${foreground};
    min-width: 250px;
    font-family: "Departure Mono";
}
.nowplaying-value {
    font-size: 15px;
    color: ${foreground};
    min-width: 185px;
    font-family: "Departure Mono";
}

.album-art {
    border-radius: 10px;
    border: 2px solid ${color3};
}

.wave-graph {
    color: #ffffff;
    min-height: 44px;
    background-image: linear-gradient(${color3}, ${color3});
    background-size: 100% 2px;
    background-repeat: no-repeat;
    background-position: center;
}


.palette {
    margin-top: 6px;
}

.swatch {
    border-radius: 100px;
    margin-right: 6px;
    border: 2px solid ${background};
}

.sz-a { min-width: 40px; min-height: 40px; }
.sz-b { min-width: 32px; min-height: 32px; }
.sz-c { min-width: 48px; min-height: 48px; }

.swatch1 { background-color: ${color1}; }
.swatch2 { background-color: ${color2}; }
.swatch3 { background-color: ${color3}; }
.swatch4 { background-color: ${color4}; }
.swatch5 { background-color: ${color5}; }
.swatch6 { background-color: ${color6}; }
CSS

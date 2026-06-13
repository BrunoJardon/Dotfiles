#!/usr/bin/env bash

CONFIG=$(mktemp)

cat > "$CONFIG" <<EOF
[general]
bars = 16
framerate = 30

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
channel_separator = ;

[smoothing]
integral = 70
monstercat = 1
waves = 1
EOF

# Caracteres para las barras
bars="▁▂▃▄▅▆▇█"

while true; do
    status=$(playerctl --player=spotify status 2>/dev/null)

    if [[ "$status" != "Playing" ]]; then
        sleep 1
        continue
    fi

    cava -p "$CONFIG" | while read -r line; do
        output=""

        IFS=';' read -ra values <<< "$line"

        for value in "${values[@]}"; do
            # Limitar rango
            if (( value < 0 )); then
                value=0
            elif (( value > 7 )); then
                value=7
            fi

            output+="${bars:value:1}"
        done

        echo "$output"
    done
done
#!/bin/bash

if [[ "$1" == "toggle" ]]; then
    if pgrep -x "swayidle" > /dev/null; then
        killall swayidle
    else
				swayidle -w \
						timeout 300 'swaylock -f' \
						timeout 600 'swaymsg "output * dpms off"' \
						resume 'swaymsg "output * dpms on"' \
						before-sleep 'systemctl hibernate' \
						after-resume 'swaymsg "output * dpms on"' &
    fi
fi

if pgrep -x "swayidle" > /dev/null; then
    echo '{"text": "", "class": "active", "tooltip": "Swayidle running"}'
else
    echo '{"text": "", "class": "inactive", "tooltip": "Swayidle inactive"}'
fi

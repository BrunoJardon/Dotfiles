#!/usr/bin/env bash

screen="󰹑  Fullscreen"
area="󰒉  Select an area"
window="󱂬  Active window"
stop_recording="  Stop recording"

dir="$HOME/Videos/Screencasts"
mkdir -p "$dir"

current_file="/tmp/screencast_current.mp4"

run_rofi() {
    echo -e "$screen\n$area\n$window\n$stop_recording" | rofi \
        -dmenu \
        -p "Screencast" \
        -mesg "Modo de grabación" \
        -theme ~/.config/rofi/applets/style.rasi
}

start_recording() {
    local geometry="$1"
    
    if pgrep -x "wf-recorder" > /dev/null; then
        notify-send "Screencast" "A recording is already in progress" -i media-record
        exit 1
    fi
    
    local filename="$dir/Recording_$(date +%Y%m%d_%H%M%S).mp4"
    echo "$filename" > "$current_file"
    
    wf-recorder -g "$geometry" -f "$filename" &
    
    notify-send "Screencast started" "Recording to $(basename "$filename")\nUse menu to stop" -i media-record
}

stop_recording_fn() {
    if pgrep -x "wf-recorder" > /dev/null; then
        pkill -INT -x "wf-recorder"
        sleep 2
        pgrep -x "wf-recorder" > /dev/null && pkill -9 -x "wf-recorder"
        
        if [[ -f "$current_file" ]]; then
            local filename=$(cat "$current_file")
            if [[ -f "$filename" ]] && [[ $(stat -c%s "$filename") -gt 0 ]]; then
                wl-copy < "$filename"
                notify-send "Screencast saved" "Saved to ~/Videos/Screencasts and copied to clipboard" -i video-x-generic
            fi
            rm -f "$current_file"
        fi
    else
        notify-send "Screencast" "No active recording found" -i dialog-warning
    fi
}

chosen="$(run_rofi)"
case ${chosen} in
    $screen)
        geometry=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused == true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
        start_recording "$geometry"
        ;;
    $area)
        area_geom=$(slurp)
        [[ -n "$area_geom" ]] && start_recording "$area_geom"
        ;;
    $window)
        win_geom=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"')
        start_recording "$win_geom"
        ;;
    $stop_recording)
        stop_recording_fn
        ;;
esac
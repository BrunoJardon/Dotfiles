#!/usr/bin/env bash

# Opciones
screen="󰹑  Fullscreen"
area="󰒉  Select an area"
window="󱂬  Active window"
delay="󱎫  Capture in 5 sec"

# Directorio de capturas
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="Screenshot_$(date +%Y%m%d_%H%M%S).png"

# Pasar opciones a Rofi
run_rofi() {
	echo -e "$screen\n$area\n$window\n$delay" | rofi \
		-dmenu \
		-p "Screenshot" \
		-mesg "Modo de captura" \
		-theme ~/.config/rofi/applets/style.rasi
}

# Lógica de captura
chosen="$(run_rofi)"
case ${chosen} in
    $screen)
        sleep 0.2 && grim "$dir/$file" && wl-copy < "$dir/$file" ;;
    $area)
        grim -g "$(slurp)" "$dir/$file" && wl-copy < "$dir/$file" ;;
    $window)
        sleep 0.2 && grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"')" "$dir/$file" && wl-copy < "$dir/$file" ;;
    $delay)
        sleep 5 && grim "$dir/$file" && wl-copy < "$dir/$file" ;;
esac

# Notificación (Opcional, si usás dunst/mako)
if [[ -f "$dir/$file" ]]; then
    notify-send "Screenshot saved" "Saved in ~/Images/Screenshots and copied to clipboard" -i camera-photo
fi
#!/usr/bin/env bash

# Opciones
lock="󰌾  Lock"
logout="󰍃  Log out"
suspend="󰤄  Suspend"
reboot="  Reboot"
shutdown="  Shutdown"

# Uptime para el prompt
uptime=$(uptime -p | sed -e 's/up //g')

# Pasar opciones a Rofi
run_rofi() {
	echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" | rofi \
		-dmenu \
		-p "Uptime: $uptime" \
		-mesg "Choose an action" \
		-theme ~/.config/rofi/powermenu/style.rasi
}

# Ejecución de comandos
chosen="$(run_rofi)"
case ${chosen} in
    $lock)
        swaylock ;;
    $logout)
        swaymsg exit ;;
    $suspend)
        systemctl suspend ;;
    $reboot)
        systemctl reboot ;;
    $shutdown)
        systemctl poweroff ;;
esac

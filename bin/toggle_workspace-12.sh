#!/bin/bash

CURRENT=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).num')

if [ "$CURRENT" = "12" ]; then
    # Si estoy en el workspace 12, voy al último workspace
    swaymsg workspace back_and_forth
else
    # Si no estoy en el 12, voy al 12
    swaymsg workspace number 12
fi
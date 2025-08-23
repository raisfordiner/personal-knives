#!/bin/sh

ROFI_CONF_DIR="$HOME/.config/rofi/multi-option.rasi"
ROFI_ARGS="-p distrobox-enter"

list="$(distrobox list | tail -n+2 | cut -d ' | ' -f 3 | tr ' ' '\n')"

chosen="$(printf "$list\n" | rofi -dmenu -config $ROFI_CONF_DIR $ROFI_ARGS)"

[ -z $chosen ] && exit || alacritty -e distrobox enter $chosen
# distrobox enter $choice

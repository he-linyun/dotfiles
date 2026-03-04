#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

# wifi: shown in clock bracket (single monitor)
item_wifi=(
  update_freq=20
  icon=󰤨
  icon.color=$(getcolor green)
  label.drawing=off
  script="$PLUGIN_DIR/wifi.sh"
)

sketchybar --add item wifi right \
           --set wifi "${item_wifi[@]}" \
           --subscribe wifi wifi_change

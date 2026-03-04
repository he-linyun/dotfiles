#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_cpu=(
  update_freq=5
  icon=CPU
  script="$PLUGIN_DIR/cpu.sh"
)
if (( MONITOR_COUNT > 1 )); then
  item_cpu+=(display=2 icon.drawing=on icon.padding_right=5)
else
  item_cpu+=(display=active icon.drawing=off icon.padding_right=0)
fi

sketchybar --add item cpu right \
           --set cpu "${item_cpu[@]}"

#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_ram=(
  update_freq=5
  icon=RAM
  script="$PLUGIN_DIR/ram.sh"
)
if (( MONITOR_COUNT > 1 )); then
  item_ram+=(display=2 icon.drawing=on icon.padding_right=5)
else
  item_ram+=(display=active icon.drawing=off icon.padding_right=0)
fi

sketchybar --add item ram right \
           --set ram "${item_ram[@]}"

#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_gpu=(
  update_freq=5
  icon=GPU
  script="$PLUGIN_DIR/gpu.sh"
)
if (( MONITOR_COUNT > 1 )); then
  item_gpu+=(display=2 icon.drawing=on icon.padding_right=5)
else
  item_gpu+=(display=active icon.drawing=off icon.padding_right=0)
fi

sketchybar --add item gpu right \
           --set gpu "${item_gpu[@]}"

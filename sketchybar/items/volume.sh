#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_volume=(
  display=1
  icon=􀊨
  icon.color=$(getcolor green)
  label.drawing=off
  script="$PLUGIN_DIR/volume.sh"
)

sketchybar --add item volume right           \
           --set volume "${item_volume[@]}"  \
           --subscribe volume volume_change
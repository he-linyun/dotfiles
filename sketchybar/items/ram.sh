#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_ram=(
  update_freq=5
  icon=RAM
  script="$PLUGIN_DIR/ram.sh"
)

sketchybar --add item ram right \
           --set ram "${item_ram[@]}"

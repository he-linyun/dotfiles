#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_cpu=(
  update_freq=5
  icon=CPU
  script="$PLUGIN_DIR/cpu.sh"
)

sketchybar --add item cpu right \
           --set cpu "${item_cpu[@]}"

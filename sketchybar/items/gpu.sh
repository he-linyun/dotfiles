#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

item_gpu=(
  update_freq=5
  icon=GPU
  script="$PLUGIN_DIR/gpu.sh"
)

sketchybar --add item gpu right \
           --set gpu "${item_gpu[@]}"

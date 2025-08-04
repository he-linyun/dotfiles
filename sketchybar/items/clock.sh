#!/usr/bin/env bash

item_clock=(
  display=1
  update_freq=20
  icon.drawing=off
  script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock right \
           --set clock "${item_clock[@]}"

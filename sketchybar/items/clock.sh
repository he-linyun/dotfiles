#!/usr/bin/env bash

if (( MONITOR_COUNT > 1 )); then
  DATE_FORMAT='%a %b %d %H:%M'
else
  DATE_FORMAT='%H:%M'
fi

item_clock=(
  display=1
  update_freq=20
  icon.drawing=off
  script="$PLUGIN_DIR/clock.sh '$DATE_FORMAT'"
)

sketchybar --add item clock right \
           --set clock "${item_clock[@]}"

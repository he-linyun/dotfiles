#!/usr/bin/env bash

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

MONITOR_COUNT=$(system_profiler SPDisplaysDataType | grep -c "Resolution")

if [[ $MONITOR_COUNT -ge 2 ]]; then
  sketchybar --set "$NAME" label="$(date '+%a %b %d %H:%M')"
else
  sketchybar --set "$NAME" label="$(date '+%H:%M')"
fi
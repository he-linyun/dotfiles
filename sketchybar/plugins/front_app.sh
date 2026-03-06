#!/usr/bin/env bash

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

HELPER_DIR="$CONFIG_DIR/helpers"

font_app_item=(
  icon="$($HELPER_DIR/icon_map.sh "$INFO")"
  icon.font="sketchybar-app-font:Regular:16.0"
  icon.drawing=on
  label="$INFO"
)


if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" "${font_app_item[@]}"
fi

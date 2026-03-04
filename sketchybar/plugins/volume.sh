#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

SF_FONT="SF Pro:Regular:14.0"

# $INFO is provided by the volume_change event
VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"

if [[ "$VOLUME" -eq 0 ]]; then
  ICON="􀊢"
  COLOR=$(getcolor red)
elif [[ "$VOLUME" -le 30 ]]; then
  ICON="􀊤"
  COLOR=$(getcolor green)
elif [[ "$VOLUME" -le 60 ]]; then
  ICON="􀊦"
  COLOR=$(getcolor green)
else
  ICON="􀊨"
  COLOR=$(getcolor green)
fi

sketchybar --set "$NAME" icon="$ICON" icon.font="$SF_FONT" icon.color="$COLOR"
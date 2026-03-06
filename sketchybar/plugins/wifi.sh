#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

NERD_FONT="Hack Nerd Font:Bold:17.0"
SF_FONT="SF Pro:Regular:14.0"

# Get Wi-Fi info from system_profiler (single call, cache output)
# this is slow
SP_OUTPUT=$(system_profiler SPAirPortDataType 2>/dev/null)

# Check if Wi-Fi is connected
if echo "$SP_OUTPUT" | grep -q "Status: Connected"; then
  # Wi-Fi connected — get signal strength
  RSSI=$(echo "$SP_OUTPUT" \
    | grep "Signal / Noise" \
    | head -1 \
    | awk -F': ' '{print $2}' \
    | awk -F' dBm' '{print $1}')

  # Map RSSI to icon
  if [ -z "$RSSI" ] || (( RSSI > -50 )); then
    ICON="󰤨"
  elif (( RSSI > -60 )); then
    ICON="󰤥"
  elif (( RSSI > -70 )); then
    ICON="󰤢"
  else
    ICON="󰤟"
  fi

  sketchybar --set "$NAME" icon="$ICON" icon.font="$NERD_FONT" icon.color=$(getcolor green)
  exit 0
fi

# Not on Wi-Fi — check for any network (e.g. personal hotspot)
if ipconfig getifaddr en0 &>/dev/null || ipconfig getifaddr en1 &>/dev/null || ipconfig getifaddr en2 &>/dev/null; then
  sketchybar --set "$NAME" icon="􀉣" icon.font="$SF_FONT" icon.color=$(getcolor white)
  exit 0
fi

# Truly disconnected
sketchybar --set "$NAME" icon="󰤭" icon.font="$NERD_FONT" icon.color=$(getcolor red)

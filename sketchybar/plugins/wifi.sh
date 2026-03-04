#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

NERD_FONT="Hack Nerd Font:Bold:17.0"
SF_FONT="SF Pro:Regular:14.0"

MONITOR_COUNT=$(aerospace list-monitors 2>/dev/null | wc -l | tr -d ' ')

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

  if [ -z "$RSSI" ]; then
    # Connected but could not read signal — show default full-bars
    sketchybar --set "$NAME" icon="󰤨" icon.font="$NERD_FONT" icon.color=$(getcolor green) label.drawing=off
    exit 0
  fi

  # Map RSSI to icon and color
  if (( RSSI > -50 )); then
    ICON="󰤨"
  elif (( RSSI > -60 )); then
    ICON="󰤥"
  elif (( RSSI > -70 )); then
    ICON="󰤢"
  else
    ICON="󰤟"
  fi
  COLOR=$(getcolor green)

  if (( MONITOR_COUNT > 1 )); then
    LABEL="${RSSI} dBm"
  else
    LABEL="${RSSI}"
  fi

  sketchybar --set "$NAME" icon="$ICON" icon.font="$NERD_FONT" icon.color="$COLOR" label="$LABEL" label.drawing=on
  exit 0
fi

# Not on Wi-Fi — check for any network (e.g. personal hotspot)
if ipconfig getifaddr en0 &>/dev/null || ipconfig getifaddr en1 &>/dev/null || ipconfig getifaddr en2 &>/dev/null; then
  sketchybar --set "$NAME" icon="􀉣" icon.font="$SF_FONT" icon.color=$(getcolor white) label.drawing=off
  exit 0
fi

# Truly disconnected
sketchybar --set "$NAME" icon="󰤭" icon.font="$NERD_FONT" icon.color=$(getcolor red) label.drawing=off

#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

# Get total CPU usage (user% + sys%)
CPU=$(top -l 1 -n 0 -s 0 | grep "CPU usage" | awk '{printf "%.0f", $3 + $5}')

case "$CPU" in
  [0-9]|[1-2][0-9])         COLOR=$(getcolor green) ;;   # 0-29%
  [3-5][0-9])               COLOR=$(getcolor yellow) ;;  # 30-59%
  [6-7][0-9])               COLOR=$(getcolor orange) ;;  # 60-79%
  *)                        COLOR=$(getcolor red) ;;     # 80%+
esac

sketchybar --set "$NAME" label="${CPU}%" label.color="$COLOR"

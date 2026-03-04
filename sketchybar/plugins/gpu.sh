#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

# Get GPU utilization on Apple Silicon
# Uses ioreg to read the GPU device utilization percentage
GPU=$(ioreg -r -d 1 -w 0 -c IOAccelerator 2>/dev/null \
  | grep -o '"Device Utilization %"=[0-9]*' \
  | head -1 \
  | awk -F'=' '{print $2}')

if [ -z "$GPU" ]; then
  GPU=0
fi

case "$GPU" in
  [0-9]|[1-2][0-9])         COLOR=$(getcolor green) ;;   # 0-29%
  [3-5][0-9])               COLOR=$(getcolor yellow) ;;  # 30-59%
  [6-7][0-9])               COLOR=$(getcolor orange) ;;  # 60-79%
  *)                        COLOR=$(getcolor red) ;;     # 80%+
esac

sketchybar --set "$NAME" label="${GPU}%" label.color="$COLOR"

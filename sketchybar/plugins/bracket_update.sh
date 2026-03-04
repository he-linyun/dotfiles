#!/usr/bin/env bash

# This script handles dynamic monitor connect/disconnect events.
# It re-evaluates MONITOR_COUNT, moves wifi, and toggles all dependent items.
# Triggered by: display_change event

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"
source "$CONFIG_DIR/defaults.sh"

# Fast monitor count via aerospace
MONITOR_COUNT=$(aerospace list-monitors | wc -l | tr -d ' ')

if (( MONITOR_COUNT > 1 )); then
  # Move wifi into sys bracket area (after sys_right)
  sketchybar --move wifi after sys_right

  # Sys bracket on secondary display with icons
  sketchybar --set bracket_gap display=2 \
             --set sys_right display=2 \
             --set cpu display=2 icon.drawing=on icon.padding_right=5 \
             --set ram display=2 icon.drawing=on icon.padding_right=5 \
             --set gpu display=2 icon.drawing=on icon.padding_right=5 \
             --set wifi display=2 \
             --set wifi_sys_gap display=2 \
             --set gpu_ram_gap display=2 \
             --set ram_cpu_gap display=2 \
             --set wifi_gap drawing=off \
             --set sys_left display=2

  # Rebuild brackets with wifi in sys bracket
  sketchybar --remove spaces_clock 2>/dev/null
  sketchybar --remove spaces_sys 2>/dev/null
  sketchybar --add bracket spaces_clock \
               notification_right clock clock_gap battery notification_left \
             --set spaces_clock "${bracket_defaults[@]}"
  sketchybar --add bracket spaces_sys \
               sys_right wifi wifi_sys_gap gpu gpu_ram_gap ram ram_cpu_gap cpu sys_left \
             --set spaces_sys "${bracket_defaults[@]}"
else
  # Move wifi back to clock bracket area (after clock_gap)
  sketchybar --move wifi after clock_gap

  # Sys bracket on all displays, numbers only
  sketchybar --set bracket_gap display=active \
             --set sys_right display=active \
             --set cpu display=active icon.drawing=off icon.padding_right=0 \
             --set ram display=active icon.drawing=off icon.padding_right=0 \
             --set gpu display=active icon.drawing=off icon.padding_right=0 \
             --set wifi_sys_gap drawing=off \
             --set gpu_ram_gap display=active \
             --set ram_cpu_gap display=active \
             --set wifi display=active \
             --set wifi_gap drawing=on \
             --set sys_left display=active

  # Rebuild brackets with wifi in clock bracket
  sketchybar --remove spaces_clock 2>/dev/null
  sketchybar --remove spaces_sys 2>/dev/null
  sketchybar --add bracket spaces_clock \
               notification_right clock clock_gap wifi wifi_gap battery notification_left \
             --set spaces_clock "${bracket_defaults[@]}"
  sketchybar --add bracket spaces_sys \
               sys_right gpu gpu_ram_gap ram ram_cpu_gap cpu sys_left \
             --set spaces_sys "${bracket_defaults[@]}"
fi

# Hide wifi label until next wifi.sh refresh updates it with correct format
sketchybar --set wifi label.drawing=off

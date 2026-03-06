#!/usr/bin/env bash

# This script handles dynamic monitor connect/disconnect events.
# It re-evaluates MONITOR_COUNT and toggles display settings for sys info items.
# Triggered by: display_change event

HELPER_DIR="$CONFIG_DIR/helpers"
PLUGIN_DIR="$CONFIG_DIR/plugins"
source "$HELPER_DIR/colors.sh"
source "$HELPER_DIR/defaults.sh"

# Fast monitor count via aerospace
MONITOR_COUNT=$(aerospace list-monitors | wc -l | tr -d ' ')

if (( MONITOR_COUNT > 1 )); then
  # Sys bracket on secondary display with icons
  sketchybar --set bracket_gap  drawing=off \
             --set sys_right    display=2 \
             --set gpu          display=2 icon.drawing=on  icon.padding_right=5 \
             --set ram          display=2 icon.drawing=on  icon.padding_right=5 \
             --set cpu          display=2 icon.drawing=on  icon.padding_right=5 \
             --set gpu_ram_gap  display=2 \
             --set ram_cpu_gap  display=2 \
             --set sys_left     display=2
  # Clock: full date format, force immediate update
  sketchybar --set clock script="$PLUGIN_DIR/clock.sh '%a %b %d %H:%M'" update_freq=20 label="$(date '+%a %b %d %H:%M')"
else
  # Sys bracket on active display, numbers only
  sketchybar --set bracket_gap  drawing=on \
             --set sys_right    display=active \
             --set gpu          display=active icon.drawing=off icon.padding_right=0 \
             --set ram          display=active icon.drawing=off icon.padding_right=0 \
             --set cpu          display=active icon.drawing=off icon.padding_right=0 \
             --set gpu_ram_gap  display=active \
             --set ram_cpu_gap  display=active \
             --set sys_left     display=active
  # Clock: compact time format, force immediate update
  sketchybar --set clock script="$PLUGIN_DIR/clock.sh '%H:%M'" update_freq=20 label="$(date '+%H:%M')"
fi

# Rebuild sys bracket
sketchybar --remove spaces_sys 2>/dev/null
sketchybar --add bracket spaces_sys \
             sys_right gpu gpu_ram_gap ram ram_cpu_gap cpu sys_left \
           --set spaces_sys "${bracket_defaults[@]}"

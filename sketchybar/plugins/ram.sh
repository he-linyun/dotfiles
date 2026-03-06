#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

# Get RAM usage percentage using vm_stat
PAGE_SIZE=$(sysctl -n vm.pagesize)
TOTAL=$(sysctl -n hw.memsize)

# active + wired + compressed = matches Activity Monitor's "Memory Used"
USED_PAGES=$(vm_stat | awk '/Pages active|Pages wired down|Pages occupied by compressor/ {gsub(/\./,"",$NF); sum+=$NF} END {print sum}')
USED=$((USED_PAGES * PAGE_SIZE))
RAM=$((USED * 100 / TOTAL))

# Color reflects the same normal/warn/critical state as Activity Monitor's memory pressure graph, NOT the raw used percentage
# kern.memorystatus_vm_pressure_level is a bitmask: normal=1, warn=2, critical=4
PRESSURE=$(sysctl -n kern.memorystatus_vm_pressure_level)

if (( PRESSURE & 4 )); then
  COLOR=$(getcolor red)
elif (( PRESSURE & 2 )); then
  COLOR=$(getcolor yellow)
else
  COLOR=$(getcolor green)
fi

sketchybar --set "$NAME" label="${RAM}%" label.color="$COLOR"
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

case "$RAM" in
  [0-9]|[1-2][0-9])         COLOR=$(getcolor green) ;;   # 0-29%
  [3-5][0-9])               COLOR=$(getcolor yellow) ;;  # 30-59%
  [6-7][0-9])               COLOR=$(getcolor orange) ;;  # 60-79%
  *)                        COLOR=$(getcolor red) ;;     # 80%+
esac

sketchybar --set "$NAME" label="${RAM}%" label.color="$COLOR"
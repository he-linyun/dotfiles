#!/usr/bin/env bash

# Initialize special workspace items (see definitions in helpers/aerospace_helper.sh)
# This script is sourced by sketchybarrc during initialization
# Dynamic updates are handled by aerospace_update.sh

source "$HELPER_DIR/aerospace_helper.sh"

for sid in "${SPECIAL[@]}"; do
  sketchybar  --add item space."$sid" e                                         \
              --set space."$sid"                                                \
                "${aerospace_item_defaults[@]}"                                 \
                "${aerospace_item_unfocused[@]}"                                \
                "${aerospace_item_popup_background_defaults[@]}"                \
                display=$(get_monitor_id "$sid")                                \
                icon="${sid:0:1}"                                               \
                label.drawing=off                                               \
                click_script="aerospace workspace $sid"

  if (( MONITOR_COUNT == 1 )); then
    sketchybar --set space."$sid" drawing=off
  fi
done

# Build SPECIAL_SPACES for bracket definitions
SPECIAL_SPACES=""
for sid in "${SPECIAL[@]}"; do
  SPECIAL_SPACES+="space.$sid "
done
SPECIAL_SPACES="${SPECIAL_SPACES% }"

# Highlight the currently focused workspace (must run after both general and special items are created)
sketchybar --set space."$(aerospace list-workspaces --focused)" "${aerospace_item_focused[@]}"
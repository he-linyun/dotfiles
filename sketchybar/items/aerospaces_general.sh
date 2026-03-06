#!/usr/bin/env bash

# Initialize general workspace items (see definitions in helpers/aerospace_helper.sh)
# This script is sourced by sketchybarrc during initialization
# Dynamic updates are handled by aerospace_update.sh

source "$HELPER_DIR/aerospace_helper.sh"

for sid in "${GENERAL[@]}"; do
  sketchybar  --add item space."$sid" left                                      \
              --set space."$sid"                                                \
                "${aerospace_item_defaults[@]}"                                 \
                "${aerospace_item_unfocused[@]}"                                \
                "${aerospace_item_popup_background_defaults[@]}"                \
                display=$(get_monitor_id "$sid")                                \
                icon="$sid"                                                     \
                label.y_offset=-1                                               \
                click_script="aerospace workspace $sid"

  if (( MONITOR_COUNT > 1 )); then
    update_workspace_icons "$sid"
  else
    if [[ -z "$(aerospace list-windows --workspace "$sid")" ]]; then
      sketchybar --set space."$sid" drawing=off
    elif [[ "$sid" == "$(aerospace list-workspaces --focused)" ]]; then
      update_workspace_icons "$sid"
    fi
  fi
done

# Build GENERAL_SPACES for bracket definitions
GENERAL_SPACES=""
for sid in "${GENERAL[@]}"; do
  GENERAL_SPACES+="space.$sid "
done
GENERAL_SPACES="${GENERAL_SPACES% }"

# Note: focused workspace highlight is applied in aerospaces_special.sh
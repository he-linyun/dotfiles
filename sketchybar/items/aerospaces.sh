#!/usr/bin/env bash

###############################################################################
## This script will NOT update dynamically, they are for initial setup only  ##
## for dynamic updates, see                                                  ##
##     $ITEM_DIR/aerospace_header.sh                                         ##
##     $PLUGIN_DIR/aerospace.sh                                              ##
###############################################################################

# This script setups the aerospace items in SketchyBar
# This script is intended to be run after aerospace_header.sh
# It requires the following variables to be set:
#   MONITOR_COUNT: is set in sketchybarrc
#   HELPER_DIR: is set in sketchybarrc

source "$HELPER_DIR/aerospace.sh"

# Build workspace and monitor arrays
WORKSPACE_NAMES=()
MONITOR_IDS=()

while IFS=- read -r ws mon; do
  WORKSPACE_NAMES+=("$ws")
  MONITOR_IDS+=("$mon")
done <<EOF
$(aerospace list-workspaces --all --format "%{workspace}-%{monitor-appkit-nsscreen-screens-id}")
EOF

# Function to get monitor id for a workspace
get_monitor_id() {
  local sid="$1"
  local v

  # Try to get the monitor id from the current windows in the workspace
  v=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}" | head -n1)
  if [[ -z "$v" ]]; then # Fallback: get from static mapping arrays
    local i
    for i in "${!WORKSPACE_NAMES[@]}"; do
      if [[ "${WORKSPACE_NAMES[$i]}" == "$sid" ]]; then
        echo "${MONITOR_IDS[$i]}"
        return
      fi
    done
  else
    echo "${v:-1}"
  fi
}

# Initialize items for each general workspace
for sid in "${GENERAL[@]}"; do
  sketchybar  --add item space."$sid" left                                      \
              --set space."$sid"                                                \
                "${aerospace_item_defaults[@]}"                                 \
                "${space_item_unfocused[@]}"                                    \
                display=$(get_monitor_id "$sid")                                \
                icon="$sid"                                                     \
                label.y_offset=-1                                               \
                click_script="aerospace workspace $sid"

  if (( MONITOR_COUNT > 1 )); then # multiple monitors: all workspaces icons and labels are displayed
    update_workspace_icons "$sid"
  else # single monitor: only display the icons of nonempty workspaces, labels are hidden except for the focused workspace
    if [[ -z "$(aerospace list-windows --workspace "$sid")" ]]; then
      sketchybar --set space."$sid" drawing=off
    elif [[ "$sid" == "$(aerospace list-workspaces --focused)" ]]; then
      update_workspace_icons "$sid"
    fi
  fi
done

# Initialize special workspaces
# when single monitor: not drawing
# multiple monitors: only display initial
for sid in "${SPECIAL[@]}"; do
  sketchybar  --add item space."$sid" e                                         \
              --set space."$sid"                                                \
                "${aerospace_item_defaults[@]}"                                 \
                "${space_item_unfocused[@]}"                                    \
                display=$(get_monitor_id "$sid")                                \
                icon="${sid:0:1}"                                               \
                label.drawing=off                                               \
                click_script="aerospace workspace $sid"

  if (( MONITOR_COUNT == 1 )); then 
    sketchybar --set space."$sid" drawing=off
  fi
done

# Initialize focused workspace: highlight
sketchybar --set space."$(aerospace list-workspaces --focused)" "${space_item_focused[@]}"

# Define space names for brackets
GENERAL_SPACES=""
for sid in "${GENERAL[@]}"; do
  GENERAL_SPACES+="space.$sid "
done
GENERAL_SPACES="${GENERAL_SPACES% }" # remove trailing space

SPECIAL_SPACES=""
for sid in "${SPECIAL[@]}"; do
  SPECIAL_SPACES+="space.$sid "
done
SPECIAL_SPACES="${SPECIAL_SPACES% }" # remove trailing space
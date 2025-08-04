#!/usr/bin/env bash

###############################################################################
## This script will not update dynamically, they are for initial setup only  ##
## for dynamic updates, see $ITEM_DIR/space_header.sh and $PLUGIN_DIR/aerospace.sh ##
###############################################################################

source "$PLUGIN_DIR/space_functions.sh"

# workspaces
# my setting: QWERTY are fixed in the built-in monitor
#             123456 are fixed in the external monitor (usually a large one)
#             all others can be moved freely
#             special workspaces contain specific apps
GENERAL=("Q" "W" "E" "R" "T" "Y"
         "1" "2" "3" "4" "5" "6"
         "A" "S" "D" "F")
SPECIAL=("Calendar" "Git" "Obsidian" "Pdf" "VS_Code" "X" "Zotero")

# aerospace item defaults
aerospace_item_defaults=(
  background.border_color=$(getcolor purple)
  background.border_width=2
  background.color=$(getcolor black)
  background.drawing=on
  background.padding_left=3
  background.padding_right=3
  drawing=on
  label.font="sketchybar-app-font:Regular:16.0"
)

                                                
#                 icon.padding_left=5                                             \
#                                  \
#                 label.padding_right=15                                          \
#                 label.padding_left=0                                            \
#                 label.y_offset=-1                                               \
#                 click_script="aerospace workspace $sid"                       
                                          
#                 icon.padding_left=5                                             \
#                 icon.padding_right=7                                            \
#                 label.drawing=off                                               \
#                 click_script="aerospace workspace $sid"                         


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
              --set space."$sid"  "${aerospace_item_defaults[@]}"               \
                display=$(get_monitor_id "$sid")                                \
                icon="$sid"                                                     \
                icon.padding_left=5                                             \
                label.padding_right=10                                          \
                label.padding_left=0                                            \
                label.y_offset=-1                                               \
                click_script="aerospace workspace $sid"
                
 update_workspace_icons "$sid"
done

# Initialize special workspaces: only display initial, hide icons if not focused
for sid in "${SPECIAL[@]}"; do
  sketchybar  --add item space."$sid" e                                         \
              --set space."$sid"  "${aerospace_item_defaults[@]}"               \
                display=$(get_monitor_id "$sid")                                \
                icon="${sid:0:1}"                                               \
                icon.padding_left=5                                             \
                icon.padding_right=5                                            \
                label.drawing=off                                               \
                click_script="aerospace workspace $sid"                         
done

# Initialize focused workspace: highlight
sketchybar --set space."$(aerospace list-workspaces --focused)"                 \
             background.border_color=$(getcolor purple)                          \
             background.color=$(getcolor cyan)                                  \
             icon.color=$(getcolor black)                                       \
             icon.shadow.drawing=off                                            \
             icon.shadow.distance=3                                             \
             label.color=$(getcolor black)                                      \
             label.shadow.drawing=off        


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


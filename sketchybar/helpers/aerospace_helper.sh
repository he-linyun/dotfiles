#!/usr/bin/env bash

###############################
## aerospace workspace setup ##
###############################

#### workspace definitions ####
# my setting: QWERTY are fixed in the built-in monitor
#             123456 are fixed in the external monitor (usually a large one)
#             all others can be moved freely
#             special workspaces contain specific apps
GENERAL=(
  "1" "2" "3" "4" "5" "6"
  "Q" "W" "E" "R" "T" "Y"
  "A" "S" "D" "F" "G"
)
SPECIAL=("Zotero" "X" "Calendar" "VS_Code" "Books" "Notes" "M")

is_workspace_special() {
  local sid="$1"
  for special in "${SPECIAL[@]}"; do
    if [[ "$sid" == "$special" ]]; then
      return 0  # true
    fi
  done
  return 1  # false
}

#### workspace and corresponding monitor id mapping ####
# workspaces and their default monitor ids
WORKSPACE_NAMES=()
MONITOR_IDS=()
while IFS=- read -r ws mon; do
  WORKSPACE_NAMES+=("$ws")
  MONITOR_IDS+=("$mon")
done <<EOF
$(aerospace list-workspaces --all --format "%{workspace}-%{monitor-appkit-nsscreen-screens-id}")
EOF

# monitor id for a workspace; will echo nothing if the workspace is empty (no opened windows)
get_active_workspace_monitor_id() {
  local sid="$1"
  echo "$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}" | head -n1)"
}

# Function to get monitor id for a workspace
get_monitor_id() {
  local sid="$1"
  local apps

  # Try to get the monitor id from the current windows in the workspace
  apps=$(get_active_workspace_monitor_id "$sid")
  if [[ -z "$apps" ]]; then # Fallback: get from static mapping arrays
    local i
    for i in "${!WORKSPACE_NAMES[@]}"; do
      if [[ "${WORKSPACE_NAMES[$i]}" == "$sid" ]]; then
        echo "${MONITOR_IDS[$i]}"
        return
      fi
    done
  else
    echo "${apps:-1}"
  fi
}

#### workspace icon drawing ####
get_workspace_icons() {
  local sid="$1"
  aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}'
}

update_workspace_icons() {
  local sid="$1"
  local apps
  apps=$(get_workspace_icons "$sid")
  if [ -z "$apps" ]; then
    sketchybar --set space."$sid"  label.drawing=off
  else
    icon_strip=" "
    while read -r app; do
      [ -z "$app" ] && continue
      icon_strip+="$($HELPER_DIR/icon_map.sh "$app")"
    done <<<"$apps"
    sketchybar --set space."$sid" label="$icon_strip" label.drawing=on
  fi
}

#############################
## workspace item defaults ##
#############################
# colors
aerospace_item_focused=(
  background.border_color=$(getcolor white)
  background.color=$(getcolor cyan)
  icon.color=$(getcolor black)
  # icon.shadow.drawing=on
  # icon.shadow.distance=3
  label.color=$(getcolor black)
  # label.shadow.drawing=on 
)

aerospace_item_unfocused=(
  background.border_color=$(getcolor purple)
  background.color=$(getcolor black)
  icon.color=$(getcolor white)
  # icon.shadow.drawing=off
  label.color=$(getcolor white)
  # label.shadow.drawing=off
)

# paddings and fonts
aerospace_item_defaults=(
  background.border_width=2
  background.drawing=on
  background.padding_left=3
  background.padding_right=3
  drawing=on
  icon.padding_left=5
  icon.padding_right=5
  label.drawing=off
  label.font="sketchybar-app-font:Regular:16.0"
  label.padding_right=10
  label.padding_left=0
)
# note: label padding would only take effect when label.drawing=on

# popups
aerospace_item_popup_background_defaults=(
  popup.background.border_width=2
  popup.background.border_color=$(getcolor purple)
  popup.background.corner_radius=10
  popup.background.color=$(getcolor white 85)
  popup.background.drawing=on
  popup.drawing=off
)

aerospace_item_popup_item_defaults=(
  icon.color=$(getcolor black)
  icon.font="sketchybar-app-font:Regular:16.0"
  icon.padding_left=5
)
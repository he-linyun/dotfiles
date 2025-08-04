#!/usr/bin/env bash

###############################
## aerospace workspace setup ##
###############################

# workspaces
# my setting: QWERTY are fixed in the built-in monitor
#             123456 are fixed in the external monitor (usually a large one)
#             all others can be moved freely
#             special workspaces contain specific apps
GENERAL=(
  "1" "2" "3" "4" "5" "6"
  "Q" "W" "E" "R" "T" "Y"
  "A" "S" "D" "F"
)
SPECIAL=("Calendar" "Git" "Obsidian" "Pdf" "VS_Code" "X" "Zotero")

update_workspace_icons() {
  local ws="$1"
  local apps
  apps=$(aerospace list-windows --workspace "$ws" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  if [ -z "$apps" ]; then
    sketchybar --set space."$ws"  label.drawing=off
  else
    icon_strip=" "
    while read -r app; do
      [ -z "$app" ] && continue
      icon_strip+="$($HELPER_DIR/icon_map.sh "$app")"
    done <<<"$apps"
    sketchybar --set space."$ws" label="$icon_strip" label.drawing=on
  fi
}

is_workspace_special() {
  local ws="$1"
  for special in "${SPECIAL[@]}"; do
    if [[ "$ws" == "$special" ]]; then
      return 0  # true
    fi
  done
  return 1  # false
}

#############################
## workspace item defaults ##
#############################
# colors
space_item_focused=(
  background.border_color=$(getcolor white)
  background.color=$(getcolor cyan)
  icon.color=$(getcolor black)
  # icon.shadow.drawing=on
  # icon.shadow.distance=3
  label.color=$(getcolor black)
  # label.shadow.drawing=on 
)

space_item_unfocused=(
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
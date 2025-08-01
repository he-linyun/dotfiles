#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_monitor_change

# workspaces
ws_general=("Q" "W" "E" "R" "T" "Y"
            "1" "2" "3" "4" "5" "6"
            "A" "S" "D" "F")
SPECIAL=("Calendar" "Git" "Obsidian" "Pdf" "VS_Code" "X" "Zotero")

# current focused workspace
FOCUSED=$(aerospace list-workspaces --focused)
background_if_focused() {
  [[ "$1" == "$2" ]] && echo "on" || echo "off"
}

# define a mapping of space names to display ids
declare -A monitor_map
workspace_list=()
while IFS=- read -r ws mon; do
  monitor_map["$ws"]="$mon"
  workspace_list+=("$ws")
done < <(aerospace list-workspaces --all --format "%{workspace}-%{monitor-appkit-nsscreen-screens-id}")

setup_ws_general_item() {
  local sid="$1"

  sketchybar  --add item space."$sid" left                                      \
              --subscribe space."$sid" aerospace_workspace_change               \
              --set space."$sid"                                                \
                display=${monitor_map[$sid]}                                    \
                drawing=on                                                      \
                background.corner_radius=5                                      \
                background.height=25                                            \
                background.padding_left=5                                       \
                background.padding_right=5                                      \
                background.drawing="$(background_if_focused "$sid" "$FOCUSED")" \
                icon="$sid"                                                     \
                icon.padding_left=5                                             \
                label.font="sketchybar-app-font:Regular:16.0"                   \
                label.padding_right=15                                          \
                label.padding_left=0                                            \
                label.y_offset=-1                                               \
                click_script="aerospace workspace $sid"                         \
                script="$PLUGIN_DIR/aerospace.sh $sid"

  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+=" $($PLUGIN_DIR/icon_map.sh "$app")"
    done <<<"${apps}"
  else
    icon_strip=""
    sketchybar --set space.$sid label.padding_right=5
  fi
  sketchybar --set space.$sid label="$icon_strip"
}

# general workspaces
for sid in "${ws_general[@]}"; do
  setup_ws_general_item "$sid"                        
done

# special workspaces
for sid in "${SPECIAL[@]}"; do
  sketchybar  --add item space."$sid" e                                         \
              --subscribe space."$sid" aerospace_workspace_change               \
              --set space."$sid"                                                \
                display=${monitor_map[$sid]}                                    \
                drawing=on                                                      \
                background.corner_radius=5                                      \
                background.height=25                                            \
                background.padding_left=3                                       \
                background.padding_right=3                                      \
                background.drawing="$(background_if_focused "$sid" "$FOCUSED")" \
                icon="${sid:0:1}"                                               \
                icon.padding_left=5                                             \
                label.font="sketchybar-app-font:Regular:16.0"                   \
                label.padding_right=5                                           \
                label.padding_left=0                                            \
                label.y_offset=-1                                               \
                click_script="aerospace workspace $sid"                         \
                script="$PLUGIN_DIR/aerospace.sh $sid"
done
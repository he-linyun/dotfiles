#!/usr/bin/env bash

# source "$CONFIG_DIR/colors.sh"
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
FOCUSED=$(aerospace list-workspaces --focused) # current focused workspace

# define a static mapping of space names to display ids, it would not update dynamically
declare -A monitor_map
while IFS=- read -r ws mon; do
  monitor_map["$ws"]="$mon"
done < <(aerospace list-workspaces --all --format "%{workspace}-%{monitor-appkit-nsscreen-screens-id}")

get_monitor_id() {
  local sid=$1
  local v
  
  # get the monitor id from the workspace, if it is empty, return results from monitor_map
  v=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}" | cut -c1)
  if [[ -z "$v" ]]; then
    echo "${monitor_map[$sid]:-1}"
  else
    echo "${v:-1}"
  fi
}

for sid in "${GENERAL[@]}"; do
  sketchybar  --add item space."$sid" left                                      \
              --set space."$sid"                                                \
                display=$(get_monitor_id "$sid")                                \
                drawing=on                                                      \
                background.corner_radius=5                                      \
                background.color=$DarkSlateBlue                                 \
                background.drawing=on                                           \
                background.padding_left=3                                       \
                background.padding_right=3                                      \
                icon="$sid"                                                     \
                icon.padding_left=5                                             \
                label.font="sketchybar-app-font:Regular:16.0"                   \
                label.padding_right=15                                          \
                label.padding_left=0                                            \
                label.y_offset=-1                                               \
                click_script="aerospace workspace $sid"                         

  update_workspace_icons "$sid"                     
done

# initialize special workspaces: only display initial, hide icons if not focused
for sid in "${SPECIAL[@]}"; do
  sketchybar  --add item space."$sid" e                                         \
              --set space."$sid"                                                \
                display=$(get_monitor_id "$sid")                                \
                drawing=on                                                      \
                background.corner_radius=5                                      \
                background.color=$DarkSlateBlue                                 \
                background.drawing=on                                           \
                background.padding_left=3                                       \
                background.padding_right=3                                      \
                icon="${sid:0:1}"                                               \
                icon.padding_left=5                                             \
                icon.padding_right=7                                            \
                label.drawing=off                                               \
                click_script="aerospace workspace $sid"                         
done

# initialize focused workspace: highlight
sketchybar --set space."$FOCUSED"                                               \
             background.border_width=2                                          \
             background.border_color=$BABYBLUE                                  \
             background.color=$RED                                              \
             icon.color=$WHITE                                                  \
             icon.shadow.drawing=on                                             \
             icon.shadow.distance=3                                             \
             label.color=$WHITE                                                 \
             label.shadow.drawing=on        

########################################
# update item according to events
########################################
# the above codes will not update dynamically, they are for initial setup only
# when subscribed event(s) is(are) triggered,
# the script "$PLUGIN_DIR/aerospace.sh" will be executed, 
# which will update the related workspace items


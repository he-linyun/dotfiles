#!/usr/bin/env bash

# This script setups the aerospace header in SketchyBar
# It requires the following variables to be set:
#   MONITOR_COUNT: is set in sketchybarrc
#   HELPER_DIR: is set in sketchybarrc

source "$HELPER_DIR/aerospace.sh"

##########################
#### basic icon setup ####
##########################
aerospace_header_extra=(
  background.border_width=0
  background.color=$(getcolor black)
  background.y_offset=-1
  icon="􀣺"
  icon.color=$(getcolor purple)
  y_offset=1
)
sketchybar --add item space_header left
sketchybar --set space_header  "${aerospace_item_defaults[@]}" "${aerospace_header_extra[@]}"

########################
#### click behavior ####
########################
aerospace_header_click=(
  click_script="sketchybar -m --set space_header popup.drawing=toggle"
  popup.background.border_width=2
  popup.background.border_color=$(getcolor purple)
  popup.background.corner_radius=10
  popup.background.color=$(getcolor white 85)
  popup.background.drawing=on
)
sketchybar --set space_header "${aerospace_header_click[@]}"

space_header_popup_defaults=(
  icon.color=$(getcolor black)
  icon.padding_left=5
  icon.padding_right=0
)
sketchybar --add item apple.preferences popup.space_header                                                      \
           --set apple.preferences "${space_header_popup_defaults[@]}" icon=􀺽                                  \
             click_script="open -a 'System Preferences'; sketchybar -m --set space_header popup.drawing=off".   \
           --add item apple.activity popup.space_header                                                         \
           --set apple.activity "${space_header_popup_defaults[@]}"    icon=􀒓                                  \
             click_script="open -a 'Activity Monitor'; sketchybar -m --set space_header popup.drawing=off".     \
           --add item apple.lock popup.space_header                                                             \
           --set apple.lock "${space_header_popup_defaults[@]}"        icon=􀒳                                  \
             click_script="pmset displaysleepnow; sketchybar -m --set space_header popup.drawing=off"

#############################
#### subscribe to events ####
#############################
space_events=(
  aerospace_workspace_change # when focus switched from one workspace to another (without changing windows in the workspace)
  aerospace_monitor_change # when a workspace is moved to a different monitor (without changing windows in the workspace)
  aerospace_move_node # when a node is moved to a different workspace
  aerospace_mode_change # sketchybar plugin event, when the mode is changed
  space_windows_change # sketchybar plugin event, when windows in a workspace are changed
  front_app_switched # sketchybar plugin event, when the front app is switched
)
sketchybar --subscribe space_header "${space_events[@]}"
sketchybar --set space_header script="$PLUGIN_DIR/aerospace.sh $MONITOR_COUNT"
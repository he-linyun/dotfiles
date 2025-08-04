#!/usr/bin/env bash

#### basic icon setup ####
sketchybar --add item space_header left                                         \
           --set space_header                                                   \
             background.color=$(getcolor black)                                 \
             background.drawing=on                                              \
             background.padding_left=3                                          \
             background.padding_right=3                                         \
             background.y_offset=-1                                             \
             icon="􀣺"                                                          \
             icon.color=$(getcolor purple)                                      \
             icon.padding_left=5                                                \
             icon.padding_right=5                                               \
             label.drawing=off                                                  \
             label.padding_left=0                                               \
             y_offset=1 

#### click behavior ####

#### aerospace events ####
space_events=(
  aerospace_workspace_change # when focus switched from one workspace to another (without changing windows in the workspace)
  aerospace_monitor_change # when a workspace is moved to a different monitor (without changing windows in the workspace)
  aerospace_move_node # when a node is moved to a different workspace
  aerospace_mode_change # sketchybar plugin event, when the mode is changed
  space_windows_change # sketchybar plugin event, when windows in a workspace are changed
  front_app_switched # sketchybar plugin event, when the front app is switched
)
sketchybar --subscribe space_header "${space_events[@]}"                        \
           --set space_header                                                   \
             script="$PLUGIN_DIR/aerospace.sh"
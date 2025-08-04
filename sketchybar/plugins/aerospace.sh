#!/usr/bin/env bash

# This script is used to manage the appearance and behavior of workspace indicators in SketchyBar.
# It listens for events:
# - aerospace_mode_change: triggered when the mode is changed in SketchyBar
# - aerospace_monitor_change: triggered when a workspace is moved to a different monitor
# - aerospace_workspace_change: triggered when a workspace is focused or changed
# - aerospace_move_node: triggered when a node is moved to a different workspace
# - space_windows_change: triggered when windows in a workspace are changed (opened/closed/moved)
# - front_app_switched: triggered when the front app is switched

# It requires the following variables to be set:
#   MONITOR_COUNT: is set in sketchybarrc
#   HELPER_DIR: is set in sketchybarrc

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"
source "$HELPER_DIR/aerospace.sh"

# aerospace_mode_change is triggered when the mode is changed
# we only need to update the space_header item
# input variables from aerospace_mode_change:
#   MODE: the mode that is set
if [[ "$SENDER" == "aerospace_mode_change" ]]; then
  if [[ "$MODE" == "service" ]]; then
    sketchybar --set space_header icon="􀀨" 
  elif [[ "$MODE" == "main" ]]; then
    sketchybar --set space_header icon="􀣺" 
  fi
  exit 0
fi

# aerospace_monitor_change is triggered when a workspace is moved to a different monitor
# the windows in that workspace will not be modified, so we can just update the display
# input variables from aerospace_workspace_change:
#   FOCUSED_WORKSPACE: the workspace that is focused
#   PREV_WORKSPACE: the workspace that was focused before
if [[ "$SENDER" == "aerospace_monitor_change" ]]; then
  sketchybar --set space."$FOCUSED_WORKSPACE" display="$TARGET_MONITOR"
  exit 0
fi

# if aerospace_workspace_change is triggered
# this is only triggerred when switching from one workspace to another
# we nonly need to update the focused and previous workspace item styles
# input variables from aerospace_monitor_change:
#   FOCUSED_WORKSPACE: the workspace that is focused
#   TARGET_MONITOR: the monitor where the focused workspace is located
if [[ "$SENDER" == "aerospace_workspace_change" ]]; then 
  # update space item styles
  sketchybar --set space."$FOCUSED_WORKSPACE" "${space_item_focused[@]}" 
  sketchybar --set space."$PREV_WORKSPACE" "${space_item_unfocused[@]}"

  # single monitor mode: only focused workspace displays the labels
  if (( MONITOR_COUNT == 1 )); then
    if ! is_workspace_special "$FOCUSED_WORKSPACE"; then
      sketchybar --set space."$FOCUSED_WORKSPACE" drawing=on
      update_workspace_icons "$FOCUSED_WORKSPACE"
    fi
    
    if [[ -z "$(aerospace list-windows --workspace "$PREV_WORKSPACE")" ]]; then
      sketchybar --set space."$PREV_WORKSPACE" drawing=off
    else
      sketchybar --set space."$PREV_WORKSPACE" label.drawing=off
    fi    
  fi
  exit 0
fi

# if aerospace_move_node is triggered
# this is triggered when a node is moved to a different workspace
# only need to update the corresponding workspace items
# input variables from aerospace_move_node:
#   OLD_WORKSPACE: the workspace where the node was before
#   NEW_WORKSPACE: the workspace where the node is moved to
if [[ "$SENDER" == "aerospace_move_node" ]]; then
  update_workspace_icons "$OLD_WORKSPACE"
  
  if (( MONITOR_COUNT > 1 )); then
    update_workspace_icons "$NEW_WORKSPACE"
  else
    sketchybar --set space."$NEW_WORKSPACE" drawing=on
  fi  
  exit 0
fi
# Note: in my aerospace setting, moving a node would not automatically change the focus
# so we do not need to make old_workspace drawing=off in this step (because it is still focused)

# if event space_windows_change is triggered
# this is triggered when windows in a workspace are changed (opened/closed/moved)
# update the icons except the special workspaces
FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"

is_special=0
for ws in "${SPECIAL[@]}"; do
  if [[ "$ws" == "$FOCUSED_WORKSPACE" ]]; then
    is_special=1
    break
  fi
done

if [[ $is_special -eq 0 ]]; then
  sketchybar --set space."$FOCUSED_WORKSPACE" drawing=on
  update_workspace_icons "$FOCUSED_WORKSPACE"
fi
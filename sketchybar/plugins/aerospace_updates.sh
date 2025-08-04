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
#   MONITOR_COUNT: is set in sketchybarrc, and is passed as an argument to this script
#   HELPER_DIR: is set in sketchybarrc

MONITOR_COUNT=$1
HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"
source "$HELPER_DIR/aerospace_helper.sh"

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
  # update space item color styles
  sketchybar --set space."$FOCUSED_WORKSPACE" "${aerospace_item_focused[@]}"
  sketchybar --set space."$PREV_WORKSPACE" "${aerospace_item_unfocused[@]}"

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
  if ! is_workspace_special "$OLD_WORKSPACE"; then
    update_workspace_icons "$OLD_WORKSPACE"
  fi
  
  if (( MONITOR_COUNT > 1 )); then
    # update the label if the new workspace is a general one
    if ! is_workspace_special "$NEW_WORKSPACE"; then
      update_workspace_icons "$NEW_WORKSPACE"
    fi    
  else
    # assumed: the new workspace was not focused, so no need to deal with labels
    # only need to set the drawing to on (if it was off)
    if ! is_workspace_special "$NEW_WORKSPACE"; then
      sketchybar --set space."$NEW_WORKSPACE" drawing=on
    fi
    
  fi  
  exit 0
fi
# Note: in my aerospace setting, moving a node would not automatically change the focus
# so we do not need to make old_workspace drawing=off in this step (because it is still focused)

# when aerospace_app_query is triggered
if [[ "$SENDER" == "aerospace_app_query" ]]; then
  # if the popup already exists, we kill all the popup items
  if sketchybar --query bar | jq -r '.items[]' | grep -q '^space_popup\.'; then
    sketchybar --set space_header icon="􀣺"
    sketchybar --remove '/space_popup\..*/'
    exit 0
  fi

  # this is designed for single monitor mode, but also callable in multiple monitor mode
  sketchybar --set space_header icon="􀁜" 
  # this for loop is unpolished -- very slow
  for sid in "${GENERAL[@]}" "${SPECIAL[@]}"; do
    apps=$(get_workspace_icons "$sid")
    if [ -z "$apps" ]; then
      continue
    fi

    idx=0
    while read -r app; do
      [ -z "$app" ] && continue
      icon="$($HELPER_DIR/icon_map.sh "$app")"
      sketchybar --add item space_popup."$sid"."$idx" popup.space."$sid"
      sketchybar --set space_popup."$sid"."$idx" "${aerospace_item_popup_item_defaults[@]}"
      sketchybar --set space_popup."$sid"."$idx" icon="$icon"
      ((idx++))
    done <<< "$apps"

    sketchybar --set space."$sid" popup.drawing=on
  done  
  exit 0
fi

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
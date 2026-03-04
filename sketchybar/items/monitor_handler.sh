#!/usr/bin/env bash

# Monitor change handler: dynamically toggles items on display connect/disconnect
# Follows the same pattern as aerospace_header.sh

sketchybar --add item monitor_handler right          \
           --set monitor_handler                     \
             drawing=off                             \
             script="$PLUGIN_DIR/bracket_update.sh"  \
           --subscribe monitor_handler display_change
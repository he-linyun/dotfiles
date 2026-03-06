#!/usr/bin/env bash

# Bracket handler: dynamically toggles sys info display on monitor connect/disconnect
# Follows the same pattern as aerospace_header.sh

sketchybar --add item bracket_handler right          \
           --set bracket_handler                     \
             drawing=off                             \
             script="$PLUGIN_DIR/bracket_update.sh"  \
           --subscribe bracket_handler display_change
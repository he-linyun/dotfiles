#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME                     \
              background.color=$RED          \
              label.shadow.drawing=on        \
              icon.shadow.drawing=on         \
              icon.shadow.distance=3         \
              background.border_width=2      \
              background.border_color=$BABYBLUE 
else
  sketchybar --set $NAME                     \
              background.color=$DarkSlateBlue\
              label.shadow.drawing=off       \
              icon.shadow.drawing=off        \
              background.border_width=0
fi
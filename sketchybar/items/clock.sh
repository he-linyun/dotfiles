#!/usr/bin/env bash

sketchybar --add item clock right                          \
           --set clock                                     \
             display=1                                     \
             update_freq=20                                \
             background.drawing=on                         \
             background.color="$DarkSlateGray"             \
             background.corner_radius=10                   \
             background.padding_left=5                     \
             background.padding_right=0                   \
             label.padding_right=5                         \
             script="$PLUGIN_DIR/clock.sh $MONITOR_COUNT"  
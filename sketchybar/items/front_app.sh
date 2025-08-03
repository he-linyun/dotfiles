#!/usr/bin/env bash

# no front app item for single monitor setups
if (( MONITOR_COUNT == 1 )); then
    exit 0
fi

sketchybar  --add item front_app q \
            --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
            --subscribe front_app front_app_switched
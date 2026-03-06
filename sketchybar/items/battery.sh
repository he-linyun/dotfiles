#!/usr/bin/env bash

sketchybar --add item battery right                    \
           --set battery                               \
             display=1                                 \
             update_freq=60                            \
             script="$PLUGIN_DIR/battery.sh"           \
           --subscribe                                 \
             battery                                   \
             system_woke                               \
             power_source_change
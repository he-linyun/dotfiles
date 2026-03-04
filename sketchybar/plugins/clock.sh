#!/usr/bin/env bash

# The date format is passed as an argument from the item definition
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

sketchybar --set "$NAME" label="$(date "+$1")"
#!/usr/bin/env bash

source "$HELPER_DIR/colors.sh"

# Bar Appearance
bar=(
  color=$TRANSPARENT
  corner_radius=0 # fine if we use transparent background
  display=all
  height=32
  #notch_width=200
  padding_left=20
  padding_right=20
  position=top
  sticky=off # visible or not in fullscreen apps
  topmost=off
)

item_defaults=(
  background.corner_radius=5
  background.height=20
  icon.font="Hack Nerd Font:Bold:17.0"
  icon.color=$(getcolor white)
  label.color=$(getcolor white)
  label.font="HSF Pro:Semibold:17.0"
  icon.padding_left=2
  icon.padding_right=1
  label.padding_left=1
  label.padding_right=2
)

bracket_defaults=(
  background.corner_radius=10
  background.color=$(getcolor white 25)
  background.height=25
)
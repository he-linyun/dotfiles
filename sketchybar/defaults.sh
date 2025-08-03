#!/usr/bin/env bash

default=(
  background.height=25
  icon.font="Hack Nerd Font:Bold:17.0"
  icon.color=$WHITE
  label.color=$WHITE
  label.font="HSF Pro:Semibold:17.0"
  icon.padding_left=2
  icon.padding_right=1
  label.padding_left=1
  label.padding_right=2
)
sketchybar --default "${default[@]}"
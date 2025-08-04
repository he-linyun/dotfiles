#!/usr/bin/env bash

# inputs:
# $1: item name
# $2: position (left, right, center, q, e)
# $3: (optional) display (default: all)
# $4: (optional) width (default: 4)

placeholder=(
  display=${3:-all}
  width=${4:-4}
  icon.padding_left=0
  icon.padding_right=0
  padding_left=0
  padding_right=0  
)

sketchybar \
  --add item $1 $2 \
  --set $1 "${placeholder[@]}"

# Note: if we name the item placeholder.$1, it will cause issues with the bracket
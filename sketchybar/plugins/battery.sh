#!/usr/bin/env bash

HELPER_DIR="$CONFIG_DIR/helpers"
source "$HELPER_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [[ "$CHARGING" != "" ]]; then
  case "${PERCENTAGE}" in
    100)    ICON="󰂅" ;;
    9[0-9]) ICON="󰂋" ;;
    8[0-9]) ICON="󰂊" ;;
    7[0-9]) ICON="󰢞" ;;
    6[0-9]) ICON="󰂉" ;;
    5[0-9]) ICON="󰢝" ;;
    4[0-9]) ICON="󰂈" ;;
    3[0-9]) ICON="󰂇" ;;
    2[0-9]) ICON="󰂆" ;;
    1[0-9]) ICON="󰢜" ;;
    [0-9])  ICON="󰢟"
  esac
else
  case "${PERCENTAGE}" in
    100)    ICON="󰁹" ;;
    9[0-9]) ICON="󰂂" ;;
    8[0-9]) ICON="󰂁" ;;
    7[0-9]) ICON="󰂀" ;;
    6[0-9]) ICON="󰁿" ;;
    5[0-9]) ICON="󰁾" ;;
    4[0-9]) ICON="󰁽" ;;
    3[0-9]) ICON="󰁼" ;;
    2[0-9]) ICON="󰁻" ;;
    1[0-9]) ICON="󰁺" ;;
    [0-9])  ICON="󰂎"
  esac
fi

# Color based on level only (not charging state)
if (( PERCENTAGE > 70 )); then
  COLOR=$(getcolor green)
elif (( PERCENTAGE > 30 )); then
  COLOR=$(getcolor yellow)
else
  COLOR=$(getcolor red)
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%"
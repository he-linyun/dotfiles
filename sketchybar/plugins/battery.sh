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
    100)    ICON="󰂅" COLOR=$(getcolor green) ;;
    9[0-9]) ICON="󰂋" COLOR=$(getcolor green) ;;
    8[0-9]) ICON="󰂊" COLOR=$(getcolor green) ;;
    7[0-9]) ICON="󰢞" COLOR=$(getcolor green) ;;
    6[0-9]) ICON="󰂉" COLOR=$(getcolor yellow) ;;
    5[0-9]) ICON="󰢝" COLOR=$(getcolor yellow) ;;
    4[0-9]) ICON="󰂈" COLOR=$(getcolor orange) ;;
    3[0-9]) ICON="󰂇" COLOR=$(getcolor orange) ;;
    2[0-9]) ICON="󰂆" COLOR=$(getcolor red) ;;
    1[0-9]) ICON="󰢜" COLOR=$(getcolor red) ;;
    [0-9]) ICON="󰢟" COLOR=$(getcolor red)
  esac
else
  case "${PERCENTAGE}" in
    100)    ICON="󰁹" COLOR=$(getcolor green) ;;
    9[0-9]) ICON="󰂂" COLOR=$(getcolor green) ;;
    8[0-9]) ICON="󰂁" COLOR=$(getcolor green) ;;
    7[0-9]) ICON="󰂀" COLOR=$(getcolor green) ;;
    6[0-9]) ICON="󰁿" COLOR=$(getcolor yellow) ;;
    5[0-9]) ICON="󰁾" COLOR=$(getcolor yellow) ;;
    4[0-9]) ICON="󰁽" COLOR=$(getcolor orange) ;;
    3[0-9]) ICON="󰁼" COLOR=$(getcolor orange) ;;
    2[0-9]) ICON="󰁻" COLOR=$(getcolor red) ;;
    1[0-9]) ICON="󰁺" COLOR=$(getcolor red) ;;
    [0-9]) ICON="󰂎" COLOR=$(getcolor red)
  esac
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%"
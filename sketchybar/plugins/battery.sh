#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [[ "$CHARGING" != "" ]]; then
  case "${PERCENTAGE}" in
    100)    ICON="󰂅" COLOR="$GREEN" ;;
    9[0-9]) ICON="󰂋" COLOR="$GREEN" ;;
    8[0-9]) ICON="󰂊" COLOR="$GREEN" ;;
    7[0-9]) ICON="󰢞" COLOR="$GREEN" ;;
    6[0-9]) ICON="󰂉" COLOR="$YELLOW";;
    5[0-9]) ICON="󰢝" COLOR="$YELLOW";;
    4[0-9]) ICON="󰂈" COLOR="$ORANGE";;
    3[0-9]) ICON="󰂇" COLOR="$ORANGE";;
    2[0-9]) ICON="󰂆" COLOR="$RED" ;;
    1[0-9]) ICON="󰢜" COLOR="$RED" ;;
    [0-9]) ICON="󰢟" COLOR="$RED"
  esac
else
  case "${PERCENTAGE}" in
    100)    ICON="󰁹" COLOR="$GREEN" ;;
    9[0-9]) ICON="󰂂" COLOR="$GREEN" ;;
    8[0-9]) ICON="󰂁" COLOR="$GREEN" ;;
    7[0-9]) ICON="󰂀" COLOR="$GREEN" ;;
    6[0-9]) ICON="󰁿" COLOR="$YELLOW";;
    5[0-9]) ICON="󰁾" COLOR="$YELLOW";;
    4[0-9]) ICON="󰁽" COLOR="$ORANGE";;
    3[0-9]) ICON="󰁼" COLOR="$ORANGE";;
    2[0-9]) ICON="󰁻" COLOR="$RED";;
    1[0-9]) ICON="󰁺" COLOR="$RED";;
    [0-9]) ICON="󰂎" COLOR="$RED"
  esac
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
#!/usr/bin/env bash

update_workspace_icons() {
  local ws="$1"
  local apps
  apps=$(aerospace list-windows --workspace "$ws" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  if [ -z "$apps" ]; then
    sketchybar --set space."$ws" icon.padding_right=5 label.drawing=off
  else
    icon_strip=" "
    while read -r app; do
      [ -z "$app" ] && continue
      icon_strip+=" $($PLUGIN_DIR/icon_map.sh "$app")"
    done <<<"$apps"
    sketchybar --set space."$ws" label="$icon_strip" label.drawing=on
  fi
}

#!/usr/bin/env sh

# modified from https://github.com/Pe8er/dotfiles/blob/master/config.symlink/sketchybar/colors.sh

##################################################
#### predefined color palettes and functions #####
##################################################

# Catpuccin Mocha https://github.com/catppuccin/catppuccin#-palette
CATPUCCIN=(
  blue "#89b4fa"
  teal "#94e2d5"
  cyan "#89dceb"
  grey "#585b70"
  green "#a6e3a1"
  yellow "#f9e2af"
  orange "#fab387"
  red "#f38ba8"
  purple "#cba6f7"
  maroon "#eba0ac"
  black "#1e1e2e"
  trueblack "#000000"
  white "#cdd6f4"
)

# Tokyo Night: https://github.com/tokyo-night/tokyo-night-vscode-theme
TOKYONIGHT=(
  blue "#7aa2f7"
  teal "#1abc9c"
  cyan "#7dcfff"
  grey "#414868"
  green "#9fe044"
  yellow "#faba4a"
  orange "#ff9e64"
  red "#f7768e"
  purple "#9d7cd8"
  maroon "#914c54"
  black "#24283b"
  trueblack "#000000"
  white "#c0caf5"
)

# functions to select the color and control the opacity of colors
# example usage:
#   background.color=$(getcolor white 50)
# WARNING: depends on the STYLE array being set
getcolor() {
  COLOR_NAME=$1
  local COLOR=""

  if [[ -z $2 ]]; then
    OPACITY=100
  else
    OPACITY=$2
  fi

  # Loop through the array to find the color hex by name
  for ((i = 0; i < ${#STYLE[@]}; i += 2)); do
    if [[ "${STYLE[i]}" == "$COLOR_NAME" ]]; then
      COLOR="${STYLE[i + 1]}"
      break
    fi
  done

  # Check if color was found
  if [[ -z $COLOR ]]; then
    echo "Invalid color name: $COLOR_NAME" >&2
    return 1
  fi

  echo $(PERCENT2HEX $OPACITY)${COLOR:1}
}

PERCENT2HEX() {
  local PERCENTAGE=$1
  local DECIMAL=$(((PERCENTAGE * 255) / 100))
  printf "0x%02X\n" "$DECIMAL"
}

###################
#### my style #####
###################

STYLE=("${TOKYONIGHT[@]}")

# extra
TRANSPARENT=0x00000000
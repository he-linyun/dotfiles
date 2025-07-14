#!/usr/bin/env bash

# Ensure the script is being run with Bash, not Zsh or another shell
if [ -z "$BASH_VERSION" ]; then
  echo "Error: This script must be run with Bash."
  exit 1
fi

set -e

DOTFILES_DIR="$HOME/.dotfiles"

FILES_TO_SYMLINK=(
  ".aerospace.toml" "$HOME/.aerospace.toml"
  ".gitconfig" "$HOME/.gitconfig"
  ".ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  "karabiner.json" "$HOME/.config/karabiner/karabiner.json"
  "nvim" "$HOME/.config/nvim"
  ".zshrc" "$HOME/.zshrc"
)

echo ""
echo "Installing dotfiles..."
echo ""

# Loop through the array two items at a time
for ((i = 0; i < ${#FILES_TO_SYMLINK[@]}; i+=2)); do
  src_relative="${FILES_TO_SYMLINK[$i]}"
  dst="${FILES_TO_SYMLINK[$((i+1))]}"
  src="$DOTFILES_DIR/$src_relative"

  echo "$src"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" != "$src" ]; then
      backup="$dst.backup.$(date +%s)"
      mv "$dst" "$backup"
      printf "\033[31mWarning:\033[0m %s already exists and is not symlinked to %s\n" "$dst" "$src"
      echo "Backed up existing file to $backup"
      echo ""
    else
      printf "\033[34mSkipped:\033[0m %s already correctly linked\n" "$dst"
      echo ""
      continue
    fi
  fi

  # Use `mkdir -p` to avoid errors if the directory already exists
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  printf "\033[32mLinked\033[0m %s → %s\n" "$src" "$dst"
  echo ""
done

echo ""
echo "All dotfiles installed!"
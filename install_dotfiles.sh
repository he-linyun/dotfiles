#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"

FILES_TO_SYMLINK=(
  ".aerospace.toml $HOME/.aerospace.toml"
  ".gitconfig $HOME/.gitconfig"
  ".zshrc $HOME/.zshrc"
)

#"nvim/init.vim $HOME/.config/nvim/init.vim"

echo ""
echo "Installing dotfiles..."

for entry in "${FILES_TO_SYMLINK[@]}"; do
  src_relative=$(echo "$entry" | awk '{print $1}')
  dst=$(echo "$entry" | awk '{print $2}')
  src="$DOTFILES_DIR/$src_relative"

  echo "→ Linking $src → $dst"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" != "$src" ]; then
      backup="$dst.backup.$(date +%s)"
      mv "$dst" "$backup"
      echo "Backed up existing file to $backup"
    else
      echo "$dst already correctly linked — skipping"
      continue
    fi
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dst")"

  ln -sf "$src" "$dst"
  echo "Linked $src → $dst"
done

echo ""
echo "All dotfiles installed!"
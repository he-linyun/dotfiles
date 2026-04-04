#!/usr/bin/env bash
set -e

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file="$HOME/.dotfiles/Brewfile"

echo "Brewfile apps installed."
#!/usr/bin/env bash
set -e

echo "Checking Homebrew installation..."

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed."
fi

echo "Installing apps from Brewfile..."
brew bundle --file="$HOME/.dotfiles/Brewfile"

echo "Brewfile apps installed."

#!/usr/bin/env bash
set -e

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file="$HOME/.dotfiles/Brewfile"

echo "All Brewfile packages installed."

install_okular() {
    echo "Fetching Okular ARM64 nightly build..."

    BASE_URL="https://cdn.kde.org/ci-builds/graphics/okular/master/macos-arm64/"
    DMG_NAME=$(curl -s "$BASE_URL" | grep -oE 'okular-master-[^"]*\.dmg' | head -n 1)
    if [ -z "$DMG_NAME" ]; then
        echo "Error: Could not locate the Okular DMG."
        return 1
    fi

    DOWNLOAD_URL="${BASE_URL}${DMG_NAME}"
    TMP_DMG="/tmp/okular_latest.dmg"

    echo "Downloading $DMG_NAME..."
    curl -L "$DOWNLOAD_URL" -o "$TMP_DMG" -#

    MOUNT_DIR=$(hdiutil attach "$TMP_DMG" -nobrowse | grep -o "/Volumes/.*" | xargs)

    # Check if Okular is already installed to avoid corruption when cp
    if [ -d "/Applications/okular.app" ] || [ -d "/Applications/Okular.app" ]; then
        echo "=> Existing Okular installation found. Removing..."
        rm -rf "/Applications/okular.app"
        rm -rf "/Applications/Okular.app"
    fi

    cp -R "$MOUNT_DIR"/*.app "/Applications/"
    hdiutil detach "$MOUNT_DIR" -force -quiet

    # Bypass Gatekeeper quarantine
    sudo xattr -rd com.apple.quarantine /Applications/okular.app

    rm "$TMP_DMG"

    echo "Okular installed successfully!"
}

install_okular
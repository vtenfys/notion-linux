#!/bin/bash
set -e

# shellcheck disable=SC1091
source scripts/setup-vars.sh "$1"

if ! [ -d "$BUILD_DIR_ENHANCED" ]; then
  # Make a copy of the build directory to enhance
  cp -R "$BUILD_DIR" "$BUILD_DIR_ENHANCED"

  # Remove the non-enhanced app package
  rm -rf "$BUILD_DIR_ENHANCED/notion-desktop-linux-$BUILD_ARCH"
fi

if ! [ -d "$BUILD_DIR_ENHANCED/.enhanced" ]; then
  # Make a backup of existing notion-desktop if one doesn't exist already
  # If a backup exists, remove any existing non-backup directory
  if [ -d /usr/lib/notion-desktop.bak ]; then
    sudo rm -rf /usr/lib/notion-desktop
  else
    sudo mv /usr/lib/notion-desktop{,.bak} || true
  fi

  # Hack: Link the app package into /usr/lib where Notion Enhancer expects it
  sudo mkdir -p /usr/lib/notion-desktop/resources
  sudo ln -s "$PWD/$BUILD_DIR_ENHANCED/app-unpacked" /usr/lib/notion-desktop/resources/app

  # Install Notion Enhancer without automatically patching
  npm install --ignore-scripts notion-enhancer

  # Explicitly apply Notion Enhancer
  notion-enhancer apply

  # Remove Notion Enhancer without automatically un-patching
  npm uninstall --ignore-scripts notion-enhancer

  # Restore original /usr/lib/notion-desktop
  sudo rm -rf /usr/lib/notion-desktop
  sudo mv /usr/lib/notion-desktop{.bak,} || true

  # Replace package name with `notion-enhanced`
  sed -i 's/"notion-desktop"/"notion-enhanced"/' "$BUILD_DIR_ENHANCED/app-unpacked/package.json"

  # Modify Notion Enhancer-patched scripts to point to the correct directory (notion-enhanced instead of notion-desktop)
  find "$BUILD_DIR_ENHANCED/app-unpacked" -name '*.js' -exec sed -i 's|/usr/lib/notion-desktop|/usr/lib/notion-enhanced|g' {} +

  # Mark as complete
  touch "$BUILD_DIR_ENHANCED/.enhanced"
fi

# Create Electron package
if ! [ -d "$BUILD_DIR_ENHANCED/notion-enhanced-linux-$BUILD_ARCH" ]; then
  electron-packager "$BUILD_DIR_ENHANCED/app-unpacked" \
    --platform linux \
    --arch "$BUILD_ARCH" \
    --out "$BUILD_DIR_ENHANCED" \
    --electron-version "$ELECTRON_VERSION"
fi

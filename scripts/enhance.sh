#!/bin/bash
set -e

# shellcheck disable=SC1091
source scripts/_variables-1.sh

usage() {
  echo "usage: $0 [ -b BUILD_ARCH ]"
  exit 1
}

while getopts "b:" options; do
  case $options in
    b)
      BUILD_ARCH=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

# shellcheck disable=SC1091
source scripts/_variables-2.sh

if ! [ -d "$BUILD_DIR_ENHANCED" ]; then
  # Make a copy of the build directory to enhance
  cp -R "$BUILD_DIR" "$BUILD_DIR_ENHANCED"

  # Remove the non-enhanced app package
  rm -rf "$BUILD_DIR_ENHANCED/notion-desktop-linux-$BUILD_ARCH"

  # Replace package name with `notion-enhanced`
  sed -i 's/"notion-desktop"/"notion-enhanced"/' "$BUILD_DIR_ENHANCED/app-unpacked/package.json"
fi

if ! [ -f "$BUILD_DIR_ENHANCED/.enhanced" ]; then
  # Make a backup of existing notion-desktop if one doesn't exist already
  # If a backup exists, remove any existing non-backup directory
  if [ -d /usr/lib/notion-desktop.bak ]; then
    sudo rm -rf /usr/lib/notion-desktop
  elif [ -d /usr/lib/notion-desktop ]; then
    sudo mv /usr/lib/notion-desktop{,.bak}
  fi

  # Hack: Link the app package into /usr/lib where Notion Enhancer expects it
  sudo mkdir -p /usr/lib/notion-desktop/resources
  sudo ln -s "$PWD/$BUILD_DIR_ENHANCED/app-unpacked" /usr/lib/notion-desktop/resources/app

  # Install Notion Enhancer and automatically apply patches
  npm install --prefix="$BUILD_DIR_ENHANCED/app-unpacked" "notion-enhancer@$ENHANCER_VERSION"

  # Restore original /usr/lib/notion-desktop
  sudo rm -rf /usr/lib/notion-desktop
  if [ -d /usr/lib/notion-desktop.bak ]; then
    sudo mv /usr/lib/notion-desktop{.bak,}
  fi

  # Modify Notion Enhancer-patched scripts to point to the correct directories
  find "$BUILD_DIR_ENHANCED/app-unpacked" -name '*.js' \
    -exec sed -i "s|/usr/lib/notion-desktop|/usr/lib/notion-enhanced|g" {} \; \
    -exec sed -i "s|$PWD/$BUILD_DIR_ENHANCED/app-unpacked/node_modules/notion-enhancer|notion-enhancer|g" {} \;

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

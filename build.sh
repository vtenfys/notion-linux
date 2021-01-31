#!/bin/bash
set -e

ELECTRON_VERSION=11.2.1
NOTION_VERSION=2.0.11
PACKAGE_REVISION=3
NOTION_BINARY=notion-$NOTION_VERSION.exe
BUILD_ARCH=${1:-x64}
BUILD_DIR=build/$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
PATH="node_modules/.bin:$PATH"

check-command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo Missing command: "$1"
    exit 1
  fi
}

commands=(node npm 7z convert g++ make)

# Check for required commands
for command in "${commands[@]}"; do
  check-command "$command"
done

# Install NPM dependencies
if ! [ -d node_modules ]; then
  npm install
fi

# Download Notion executable
if ! [ -f $NOTION_BINARY ]; then
  origin=https://desktop-release.notion-static.com
  wget "$origin/Notion%20Setup%20$NOTION_VERSION.exe" -O $NOTION_BINARY
fi

# Setup the build directory
mkdir -p "$BUILD_DIR"

# Extract the Notion executable
if ! [ -f "$BUILD_DIR/notion-exe/\$PLUGINSDIR/app-64.7z" ]; then
  7z x $NOTION_BINARY -o"$BUILD_DIR/notion-exe"
fi

# Extract the app bundle
if ! [ -f "$BUILD_DIR/app-bundle/resources/app.asar" ]; then
  7z x "$BUILD_DIR/notion-exe/\$PLUGINSDIR/app-64.7z" -o"$BUILD_DIR"/app-bundle
fi

# Extract the app container
if ! [ -d "$BUILD_DIR/app-unpacked" ]; then
  asar extract \
    "$BUILD_DIR/app-bundle/resources/app.asar" "$BUILD_DIR/app-unpacked"
fi

# Install NPM dependencies and apply patches
if ! [ -f "$BUILD_DIR/app-unpacked/package-lock.json" ]; then
  # Replace package name to fix some issues:
  # - conflicting package in Ubuntu repos called "notion"
  # - icon not showing up properly when only the DEB package is renamed
  sed -i 's/"Notion"/"notion-desktop"/' "$BUILD_DIR/app-unpacked/package.json"

  # Patch to treat the Linux app like the Windows version
  # Adds support for some missing features such as Google/Apple login
  sed -i 's/process\.platform === "win32"/process\.platform === "linux"/g' "$BUILD_DIR/app-unpacked/main/main.js"

  # Patch to show the latest release when an update is available
  echo >> "$BUILD_DIR/app-unpacked/main/main.js"
  cat update.js >> "$BUILD_DIR/app-unpacked/main/main.js"

  # Remove existing node_modules
  rm -rf "$BUILD_DIR/app-unpacked/node_modules"

  # Configure build settings
  # See https://www.electronjs.org/docs/tutorial/using-native-node-modules
  export npm_config_target=$ELECTRON_VERSION
  export npm_config_arch=$BUILD_ARCH
  export npm_config_target_arch=$BUILD_ARCH
  export npm_config_disturl=https://electronjs.org/headers
  export npm_config_runtime=electron
  export npm_config_build_from_source=true

  HOME=~/.electron-gyp npm install --prefix "$BUILD_DIR/app-unpacked" open
fi

# Convert icon.ico to PNG
if ! [ -f "$BUILD_DIR/app-unpacked/icon.png" ]; then
  convert \
    "$BUILD_DIR/app-unpacked/icon.ico[0]" "$BUILD_DIR/app-unpacked/icon.png"
fi

# Create Electron package
if ! [ -d "$BUILD_DIR/app-linux-$BUILD_ARCH" ]; then
  electron-packager "$BUILD_DIR/app-unpacked" app \
    --platform linux \
    --arch "$BUILD_ARCH" \
    --out "$BUILD_DIR" \
    --electron-version $ELECTRON_VERSION \
    --executable-name notion-desktop
fi

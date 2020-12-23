#!/bin/bash
set -e

ELECTRON_VERSION=11.1.1
NOTION_BINARY=notion.exe
BUILD_ARCH=${1:-x64}
PACKAGE_ARCH=${2:-amd64}
BUILD_DIR=build-$BUILD_ARCH
PATH="node_modules/.bin:$PATH"

# Check for Notion installer
if ! [ -f $NOTION_BINARY ]; then
  echo Notion installer missing!
  echo Please download Notion for Windows from https://www.notion.so/desktop \
    and place the installer in this directory as $NOTION_BINARY
  exit 1
fi

check-command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo Missing command: "$1"
    exit 1
  fi
}

commands=(node npm 7z convert fakeroot dpkg g++ make)

# Check for required commands
for command in "${commands[@]}"; do
  check-command "$command"
done

# Install NPM dependencies
if ! [ -d node_modules ]; then
  npm install
fi

# Setup the build directory
mkdir -p "$BUILD_DIR"

# Extract the Notion executable
if ! [ -f "$BUILD_DIR/notion/\$PLUGINSDIR/app-64.7z" ]; then
  7z x $NOTION_BINARY -o"$BUILD_DIR/notion"
fi

# Extract the app bundle
if ! [ -f "$BUILD_DIR/bundle/resources/app.asar" ]; then
  7z x "$BUILD_DIR/notion/\$PLUGINSDIR/app-64.7z" -o"$BUILD_DIR"/bundle
fi

# Extract the app container
if ! [ -d "$BUILD_DIR/app" ]; then
  asar extract "$BUILD_DIR/bundle/resources/app.asar" "$BUILD_DIR/app"
fi

# Install NPM dependencies
if ! [ -f "$BUILD_DIR/app/package-lock.json" ]; then
  # Replace package name to fix some issues:
  # - conflicting package in Ubuntu repos called "notion"
  # - icon not showing up properly when only the DEB package is renamed
  sed -i 's/"Notion"/"notion-desktop"/' "$BUILD_DIR/app/package.json"

  # Remove existing node_modules
  rm -rf "$BUILD_DIR/app/node_modules"

  # Configure build settings
  # See https://www.electronjs.org/docs/tutorial/using-native-node-modules
  export npm_config_target=$ELECTRON_VERSION
  export npm_config_arch=$BUILD_ARCH
  export npm_config_target_arch=$BUILD_ARCH
  export npm_config_disturl=https://electronjs.org/headers
  export npm_config_runtime=electron
  export npm_config_build_from_source=true

  HOME=~/.electron-gyp npm install --prefix "$BUILD_DIR/app"
fi

# Convert icon.ico to PNG
if ! [ -f "$BUILD_DIR/app/icon.png" ]; then
  convert "$BUILD_DIR/app/icon.ico[0]" "$BUILD_DIR/app/icon.png"
fi

# Create Electron distribution
if ! [ -d "$BUILD_DIR/dist" ]; then
  electron-packager "$BUILD_DIR/app" app \
    --platform linux \
    --arch "$BUILD_ARCH" \
    --out "$BUILD_DIR/dist" \
    --electron-version $ELECTRON_VERSION \
    --executable-name notion-desktop
fi

# Create Debian package
electron-installer-debian \
  --src "$BUILD_DIR/dist/app-linux-$BUILD_ARCH" \
  --dest out \
  --arch "$PACKAGE_ARCH" \
  --options.productName Notion \
  --options.icon "$BUILD_DIR/app/icon.png"

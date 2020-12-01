#!/bin/bash
set -e

ELECTRON_VERSION=6.1.12
NOTION_BINARY=notion.exe
PATH="node_modules/.bin:$PATH"

# Check for Notion installer
if ! [ -f $NOTION_BINARY ]; then
  echo Notion installer missing!
  echo Please download Notion for Windows from https://www.notion.so/desktop \
    and place the installer in this directory as $NOTION_BINARY
  exit 1
fi

# Check for required commands
check-command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo Missing command: "$1"
    exit 1
  fi
}

commands=(
  node npm asar electron-packager electron-installer-debian
  7z convert fakeroot dpkg g++ make
)

for command in "${commands[@]}"; do
  check-command "$command"
done

# Setup the build directory
mkdir -p build

# Extract the Notion executable
if ! [ -f "build/notion/\$PLUGINSDIR/app-64.7z" ]; then
  7z x $NOTION_BINARY -obuild/notion
fi

# Extract the app bundle
if ! [ -f build/bundle/resources/app.asar ]; then
  7z x "build/notion/\$PLUGINSDIR/app-64.7z" -obuild/bundle
fi

# Extract the app container
if ! [ -d build/app ]; then
  asar extract build/bundle/resources/app.asar build/app
fi

# Install NPM dependencies
if ! [ -f build/app/package-lock.json ]; then
  # Replace package name to fix some issues:
  # - conflicting package in Ubuntu repos called "notion"
  # - icon not showing up properly when only the DEB package is renamed
  sed -i 's/"Notion"/"notion-desktop"/' build/app/package.json

  # Remove existing node_modules
  rm -rf build/app/node_modules

  # Configure build settings
  # See https://www.electronjs.org/docs/tutorial/using-native-node-modules
  export npm_config_target=$ELECTRON_VERSION
  export npm_config_arch=x64
  export npm_config_target_arch=x64
  export npm_config_disturl=https://electronjs.org/headers
  export npm_config_runtime=electron
  export npm_config_build_from_source=true

  HOME=~/.electron-gyp npm install --prefix build/app
fi

# Convert icon.ico to PNG
if ! [ -f build/app/icon.png ]; then
  convert 'build/app/icon.ico[0]' build/app/icon.png
fi

# Create Electron distribution
if ! [ -d build/dist ]; then
  electron-packager build/app app \
    --platform linux \
    --arch x64 \
    --out build/dist \
    --electron-version $ELECTRON_VERSION \
    --executable-name notion-desktop
fi

# Create Debian package
electron-installer-debian \
  --src build/dist/app-linux-x64 \
  --dest out \
  --arch amd64 \
  --options.productName Notion \
  --options.icon build/dist/app-linux-x64/resources/app/icon.png

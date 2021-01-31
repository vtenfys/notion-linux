#!/bin/bash
set -e

NOTION_VERSION=2.0.11
PACKAGE_REVISION=4
BUILD_ARCH=${1:-x64}
PACKAGE_ARCH=${2:-amd64}
BUILD_DIR=build/$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
PATH="node_modules/.bin:$PATH"

# Check for required command
if ! command -v dpkg >/dev/null 2>&1; then
  echo Missing command: dpkg
  exit 1
fi

# Create Debian package
if ! [ -f "out/notion-desktop_${NOTION_VERSION}_$PACKAGE_ARCH.deb" ]; then
  electron-installer-debian \
    --src "$BUILD_DIR/app-linux-$BUILD_ARCH" \
    --dest out \
    --arch "$PACKAGE_ARCH" \
    --options.productName Notion \
    --options.icon "$BUILD_DIR/app-unpacked/icon.png" \
    --options.revision $PACKAGE_REVISION
fi

#!/bin/bash
set -e

NOTION_VERSION=2.0.11
PACKAGE_REVISION=3
BUILD_ARCH=${1:-x64}
PACKAGE_ARCH=${2:-amd64}
BUILD_DIR=build/build-$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
PATH="node_modules/.bin:$PATH"

check-command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo Missing command: "$1"
    exit 1
  fi
}

commands=(dpkg fakeroot)

# Check for required commands
for command in "${commands[@]}"; do
  check-command "$command"
done

# Create Debian package
if ! [ -f "out/notion-desktop_$NOTION_VERSION-${PACKAGE_REVISION}_$PACKAGE_ARCH.deb" ]; then
  electron-installer-debian \
    --src "$BUILD_DIR/app-linux-$BUILD_ARCH" \
    --dest out/debs \
    --arch "$PACKAGE_ARCH" \
    --options.productName Notion \
    --options.icon "$BUILD_DIR/app-linux-$BUILD_ARCH/resources/app/icon.png" \
    --options.revision $PACKAGE_REVISION
fi

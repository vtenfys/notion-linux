#!/bin/bash
set -e

NOTION_VERSION=2.0.11
PACKAGE_REVISION=3
BUILD_ARCH=${1:-x64}
PACKAGE_ARCH=${2:-x86_64}
BUILD_DIR=build/$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
PATH="node_modules/.bin:$PATH"

# Check for required command
if ! command -v rpmbuild >/dev/null 2>&1; then
  echo Missing command: rpmbuild
  exit 1
fi

# Create Red Hat package
if ! [ -f "out/notion-desktop_${NOTION_VERSION}_$PACKAGE_ARCH.deb" ]; then
  electron-installer-redhat \
    --src "$BUILD_DIR/app-linux-$BUILD_ARCH" \
    --dest out \
    --arch "$PACKAGE_ARCH" \
    --options.productName Notion \
    --options.icon "$BUILD_DIR/app-linux-$BUILD_ARCH/resources/app/icon.png" \
    --options.revision $PACKAGE_REVISION \
    --options.license Other
fi

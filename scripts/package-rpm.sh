#!/bin/bash
set -e

# shellcheck disable=SC1091
source scripts/setup-vars.sh "$2" "$3"

APP_NAME=$1
PRODUCT_NAME=Notion
if [[ "$APP_NAME" == notion-enhanced ]]; then
  BUILD_DIR=$BUILD_DIR_ENHANCED
  PRODUCT_NAME='Notion Enhanced'
fi

# Check for required command
if ! command -v rpmbuild >/dev/null 2>&1; then
  echo Missing command: rpmbuild
  exit 1
fi

# Create Red Hat package
if ! [ -f "out/rpms/$APP_NAME-$NOTION_VERSION-$PACKAGE_REVISION.$PACKAGE_ARCH.rpm" ]; then
  electron-installer-redhat \
    --src "$BUILD_DIR/$APP_NAME-linux-$BUILD_ARCH" \
    --dest out/rpms \
    --arch "$PACKAGE_ARCH" \
    --options.productName "$PRODUCT_NAME" \
    --options.icon "$BUILD_DIR/$APP_NAME-linux-$BUILD_ARCH/resources/app/icon.png" \
    --options.desktopTemplate templates/desktop-rpm.ejs \
    --options.revision "$PACKAGE_REVISION" \
    --options.license Other
fi

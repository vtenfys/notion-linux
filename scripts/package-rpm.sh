#!/bin/bash
set -e

# shellcheck disable=SC1091
source scripts/setup-vars.sh "${1:-x64}" "${2:-x86_64}"

# Check for required command
if ! command -v rpmbuild >/dev/null 2>&1; then
  echo Missing command: rpmbuild
  exit 1
fi

# Create Red Hat package
if ! [ -f "out/rpms/notion-desktop-$NOTION_VERSION-$PACKAGE_REVISION.$PACKAGE_ARCH.rpm" ]; then
  electron-installer-redhat \
    --src "$BUILD_DIR/notion-desktop-linux-$BUILD_ARCH" \
    --dest out/rpms \
    --arch "$PACKAGE_ARCH" \
    --options.productName Notion \
    --options.icon "$BUILD_DIR/notion-desktop-linux-$BUILD_ARCH/resources/app/icon.png" \
    --options.desktopTemplate templates/desktop-rpm.ejs \
    --options.revision "$PACKAGE_REVISION" \
    --options.license Other
fi

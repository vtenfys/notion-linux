#!/bin/bash
set -e

# shellcheck disable=SC1091
source scripts/_variables-1.sh x86_64

usage() {
  echo "usage: $0 [ -n APP_NAME -b BUILD_ARCH ]"
  exit 1
}

while getopts "n:b:" options; do
  case $options in
    n)
      APP_NAME=$OPTARG
      ;;
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

if [[ "$BUILD_ARCH" == arm64 ]]; then
  PACKAGE_ARCH=aarch64
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

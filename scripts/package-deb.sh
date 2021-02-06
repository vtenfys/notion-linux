#!/bin/bash
set -e

# shellcheck disable=SC1091
source scripts/_variables-1.sh amd64

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
  PACKAGE_ARCH=arm64
fi

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
if ! [ -f "out/debs/${APP_NAME}_$NOTION_VERSION-${PACKAGE_REVISION}_$PACKAGE_ARCH.deb" ]; then
  electron-installer-debian \
    --src "$BUILD_DIR/$APP_NAME-linux-$BUILD_ARCH" \
    --dest out/debs \
    --arch "$PACKAGE_ARCH" \
    --options.productName "$PRODUCT_NAME" \
    --options.icon "$BUILD_DIR/$APP_NAME-linux-$BUILD_ARCH/resources/app/icon.png" \
    --options.desktopTemplate templates/desktop-deb.ejs \
    --options.revision "$PACKAGE_REVISION"
fi

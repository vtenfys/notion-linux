#!/bin/bash

export ELECTRON_VERSION=11.2.2
export NOTION_VERSION=2.0.11
export PACKAGE_REVISION=5
export BUILD_ARCH=x64
export PACKAGE_ARCH=$1

export RESOURCE_DIR=build/resources-$NOTION_VERSION
export BUILD_DIR=build/build-$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
export BUILD_DIR_ENHANCED=build/build-enhanced-$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
export PATH="node_modules/.bin:$PATH"

export APP_NAME=notion-desktop
export PRODUCT_NAME=Notion

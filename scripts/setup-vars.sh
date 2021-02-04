#!/bin/bash

export ELECTRON_VERSION=11.2.2
export NOTION_VERSION=2.0.11
export PACKAGE_REVISION=5
export BUILD_ARCH=$1
export PACKAGE_ARCH=$2

export RESOURCE_DIR=build/resources-$NOTION_VERSION
export BUILD_DIR=build/build-$NOTION_VERSION-$PACKAGE_REVISION-$BUILD_ARCH
export PATH="node_modules/.bin:$PATH"

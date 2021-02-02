#!/bin/bash
set -e

mkdir -p public
cd public
wget 'https://api.cirrus-ci.com/v1/artifact/github/davidbailey00/notion-linux-builder/Create RPM repo/rpm_repo.zip'
unzip rpm_repo.zip

#!/bin/bash
set -e

for deb in out/debs/*.deb; do
  curl -F package=@"$deb" https://$GEMFURY_TOKEN@push.fury.io/davidbailey00/
done

for rpm in out/rpms/*.rpm; do
  curl -F package=@"$rpm" https://$GEMFURY_TOKEN@push.fury.io/davidbailey00/
done

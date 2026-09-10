#!/usr/bin/env bash

set -euo pipefail

readonly appimagetool_url='https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage'
readonly appimagetool_sha256='a6d71e2b6cd66f8e8d16c37ad164658985e0cf5fcaa950c90a482890cb9d13e0'
readonly appimagetool_path="${RUNNER_TEMP:-/tmp}/appimagetool-x86_64.AppImage"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  patchelf desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse

# Install appimagetool AppImage
curl --fail --location --silent --show-error "$appimagetool_url" --output "$appimagetool_path"
printf '%s  %s\n' "$appimagetool_sha256" "$appimagetool_path" | sha256sum --check --status
chmod +x "$appimagetool_path"

cp -r ./build/linux/x64/release/bundle/ ./build/linux/x64/flut-renamer.AppDir
cp -r ./appimage/flut-renamer.desktop ./build/linux/x64/flut-renamer.AppDir
cp -r ./assets/desktop.png ./build/linux/x64/flut-renamer.AppDir
cp -r ./appimage/AppRun ./build/linux/x64/flut-renamer.AppDir
chmod +x ./build/linux/x64/flut-renamer.AppDir/AppRun
"$appimagetool_path" ./build/linux/x64/flut-renamer.AppDir
rm -rf -- ./build/linux/x64/flut-renamer.AppDir

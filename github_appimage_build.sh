#!/usr/bin/env bash
set -euo pipefail

architecture=${1:-x64}
output_dir=${2:-.}
case "$architecture" in
  x64)
    appimage_arch=x86_64
    checksum=ed4ce84f0d9caff66f50bcca6ff6f35aae54ce8135408b3fa33abfc3cb384eb0
    ;;
  arm64)
    appimage_arch=aarch64
    checksum=f0837e7448a0c1e4e650a93bb3e85802546e60654ef287576f46c71c126a9158
    ;;
  *) echo "Unsupported architecture: $architecture" >&2; exit 1 ;;
esac

work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$output_dir"
curl --fail --location --silent --show-error --retry 3 \
  "https://github.com/AppImage/appimagetool/releases/download/1.9.1/appimagetool-${appimage_arch}.AppImage" \
  --output "$work/appimagetool"
printf '%s  %s\n' "$checksum" "$work/appimagetool" | sha256sum --check --status
chmod +x "$work/appimagetool"
cp -a "build/linux/$architecture/release/bundle" "$work/AppDir"
cp appimage/flut-renamer.desktop assets/desktop.png appimage/AppRun "$work/AppDir/"
chmod +x "$work/AppDir/AppRun"
# Extraction mode works on hosted runners without FUSE.
ARCH="$appimage_arch" APPIMAGE_EXTRACT_AND_RUN=1 "$work/appimagetool" \
  "$work/AppDir" "$output_dir/Flut_Renamer-${appimage_arch}.AppImage"

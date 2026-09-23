#!/usr/bin/env bash
set -euo pipefail
architecture=${1:?Usage: flatpak.sh x64|arm64 OUTPUT_DIR}
out=$(realpath -m "${2:?Missing output directory}")
case "$architecture" in
  x64) flatpak_arch=x86_64 ;;
  arm64) flatpak_arch=aarch64 ;;
  *) echo "Unsupported architecture: $architecture" >&2; exit 1 ;;
esac
app_id=net.sunjiao.renamer
# GNOME 50 supplies GTK 3 and a glibc newer than our Ubuntu 24.04 build host.
runtime_version=50
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$out"
# Flatpak rejects raster icons larger than 512px. Match the 256x256 theme path.
convert assets/desktop.png -resize 256x256 -background none -gravity center \
  -extent 256x256 -strip "PNG32:$work/desktop.png"
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user --noninteractive --arch="$flatpak_arch" flathub \
  "org.gnome.Platform//$runtime_version" "org.gnome.Sdk//$runtime_version"
# build-init searches installed runtimes, including the user installation.
# Unlike remote-add/install, it does not accept --user.
flatpak build-init --arch="$flatpak_arch" "$work/app" "$app_id" \
  org.gnome.Sdk org.gnome.Platform "$runtime_version"
mkdir -p "$work/app/files/lib/flut-renamer" "$work/app/files/bin" \
  "$work/app/files/share/applications" "$work/app/files/share/icons/hicolor/256x256/apps"
cp -a "build/linux/$architecture/release/bundle/." "$work/app/files/lib/flut-renamer/"
printf '#!/bin/sh\nexec /app/lib/flut-renamer/flut-renamer "$@"\n' > "$work/app/files/bin/flut-renamer"
chmod +x "$work/app/files/bin/flut-renamer"
sed "s/^Icon=.*/Icon=$app_id/" appimage/flut-renamer.desktop > "$work/app/files/share/applications/$app_id.desktop"
install -m644 "$work/desktop.png" "$work/app/files/share/icons/hicolor/256x256/apps/$app_id.png"
# Renaming arbitrary selected files and drag/drop requires host filesystem access.
flatpak build-finish --command=flut-renamer --share=ipc --socket=x11 \
  --socket=wayland --device=dri --filesystem=host "$work/app"
flatpak build-export --arch="$flatpak_arch" "$work/repo" "$work/app" stable
flatpak build-bundle --arch="$flatpak_arch" \
  --runtime-repo=https://dl.flathub.org/repo/flathub.flatpakrepo \
  "$work/repo" "$out/flut-renamer-${flatpak_arch}.flatpak" "$app_id" stable

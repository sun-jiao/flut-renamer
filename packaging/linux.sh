#!/usr/bin/env bash
# Package a native Flutter release bundle. Dependencies are installed by CI.
set -euo pipefail
architecture=${1:?Usage: linux.sh x64|arm64 VERSION OUTPUT_DIR}
version=${2:?Missing version}
out=$(realpath -m "${3:?Missing output directory}")
case "$architecture" in
  x64) native_arch=x86_64; deb_arch=amd64 ;;
  arm64) native_arch=aarch64; deb_arch=arm64 ;;
  *) echo "Unsupported architecture: $architecture" >&2; exit 1 ;;
esac
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo 'Expected a numeric X.Y.Z release version' >&2; exit 1; }
bundle="build/linux/$architecture/release/bundle"
test -x "$bundle/flut-renamer"
mkdir -p "$out"
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
root="$work/root"
mkdir -p "$root/opt/flut-renamer" "$root/usr/bin" "$root/usr/share/applications" \
  "$root/usr/share/icons/hicolor/256x256/apps" "$root/usr/share/licenses/flut-renamer"
cp -a "$bundle/." "$root/opt/flut-renamer/"
ln -s /opt/flut-renamer/flut-renamer "$root/usr/bin/flut-renamer"
sed 's/^Icon=.*/Icon=flut-renamer/' appimage/flut-renamer.desktop > "$root/usr/share/applications/flut-renamer.desktop"
install -m644 assets/desktop.png "$root/usr/share/icons/hicolor/256x256/apps/flut-renamer.png"
install -m644 LICENSE "$root/usr/share/licenses/flut-renamer/LICENSE"
desktop-file-validate "$root/usr/share/applications/flut-renamer.desktop"

common=(-s dir -C "$root" -n flut-renamer -v "$version" --iteration 1
  --license GPL-3.0-only --maintainer 'Sun Jiao'
  --url "https://github.com/${GITHUB_REPOSITORY:-sun-jiao/renamer}"
  --description 'Batch rename files and directories with Flut Renamer')
fpm "${common[@]}" -t deb -a "$deb_arch" \
  -d 'libc6 (>= 2.39)' -d libgtk-3-0 -d libstdc++6 -d liblzma5 -d libgl1 -d libegl1 \
  -p "$out/flut-renamer_${version}_${deb_arch}.deb" .
fpm "${common[@]}" -t rpm -a "$native_arch" \
  -d 'glibc >= 2.39' -d gtk3 -d libstdc++ -d xz-libs -d libglvnd-glx -d libglvnd-egl \
  -p "$out/flut-renamer-${version}-1.${native_arch}.rpm" .
if [[ "$architecture" == x64 ]]; then
  fpm "${common[@]}" -t pacman -a x86_64 \
    -d 'glibc>=2.39' -d gtk3 -d gcc-libs -d xz -d libglvnd \
    -p "$out/flut-renamer-${version}-1-x86_64.pkg.tar.zst" .
fi

tar -C "$bundle" -czf "$out/flut-renamer-linux-${native_arch}.tar.gz" .
# Keep the old x64 download URL working, now with actual gzip compression.
if [[ "$architecture" == x64 ]]; then
  cp "$out/flut-renamer-linux-${native_arch}.tar.gz" "$out/flut-renamer-linux.tar.gz"
fi

# Self-contained Nix input: default.nix and the native bundle travel together.
mkdir -p "$work/nix/bundle"
cp -a "$bundle/." "$work/nix/bundle/"
cp assets/desktop.png LICENSE "$work/nix/"
cp "$root/usr/share/applications/flut-renamer.desktop" "$work/nix/"
sed -e "s/@VERSION@/$version/g" -e "s/@SYSTEM@/${native_arch}-linux/g" \
  packaging/nix/default.nix > "$work/nix/default.nix"
tar -C "$work/nix" -czf "$out/flut-renamer-${version}-${native_arch}.nix.tar.gz" .

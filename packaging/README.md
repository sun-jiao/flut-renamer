# Release packages

Pushing a `vX.Y.Z` or `vX.Y.Z-suffix` tag whose base version matches `pubspec.yaml` runs
`.github/workflows/main.yml`. All jobs must succeed before publishing. Existing
Android signing secrets are still required. No registry credentials are needed
for the new packages. `x86` here means **x86_64**, not 32-bit i686.

Tags such as `v1.6.3-new-packages-test` are published as GitHub prereleases.
Linux package versions use the base `1.6.3` to match the compiled application;
these test packages therefore have the same native package version as the
corresponding stable release. Homebrew, Scoop and Winget manifests retain the
suffix in their version, and all download URLs retain the complete tag.
Suffixes may contain ASCII letters, digits, hyphens, and dot-separated segments
(for example, `beta`, `rc.1`, or `new-packages-test`).

Linux arm64 bootstraps Flutter from the exact official Git tag specified by
`FLUTTER_VERSION`, because flutter-action's SDK archive lookup does not provide
a Linux arm64 bundle. Other platforms continue to use flutter-action.

| Platform | Release assets |
| --- | --- |
| Linux x86_64 / arm64 | `.AppImage`, `.flatpak`, `.deb`, `.rpm`, `.nix.tar.gz`, native `.tar.gz` |
| Linux x86_64 | `.pkg.tar.zst` (Pacman) |
| macOS | Existing `.dmg` plus `flut-renamer.rb` (Homebrew cask) |
| Windows x64 | Existing portable `.exe` plus `flut-renamer.json` (Scoop) and `FlutRenamer.FlutRenamer.yaml` (Winget) |

Linux uses native Ubuntu 24.04 runners. The native packages and AppImages require
a compatible system (glibc 2.39 or newer and GTK 3); the AppImage bundles the
Flutter libraries but does not bundle all system libraries. Flatpak uses the
GNOME 50 runtime and grants host filesystem access for batch renaming and drag
and drop. Nix packages patch the native binaries against Nixpkgs dependencies;
CI builds each architecture with Nixpkgs 26.05 before upload. The Nix package
includes headless OpenJDK 17 to resolve the bundled `libdartjni.so` dependency
on `libjvm.so`; autoPatchelf searches OpenJDK's `lib/server` directory explicitly.

`SHA256SUMS` covers every other release asset. Manager manifests are generated
from the actual DMG/EXE hashes and the workflow repository, so forks get their
own download URLs. The existing `flut-renamer-linux.tar.gz` x64 URL is retained.

## Install downloaded Linux packages

Choose the asset for your CPU. Examples below use x86_64 and version 1.6.3:

```sh
sudo apt install ./flut-renamer_1.6.3_amd64.deb
sudo dnf install ./flut-renamer-1.6.3-1.x86_64.rpm
sudo pacman -U ./flut-renamer-1.6.3-1-x86_64.pkg.tar.zst
flatpak install --user ./flut-renamer-x86_64.flatpak
flatpak run net.sunjiao.renamer
```

For Nix, extract the archive into its own directory, then use a compatible
Nixpkgs channel (CI uses `nixos-26.05`):

```sh
mkdir flut-renamer-nix
tar -xzf flut-renamer-1.6.3-x86_64.nix.tar.gz -C flut-renamer-nix
nix-build ./flut-renamer-nix
./result/bin/flut-renamer
# Optionally install into a legacy Nix profile:
nix-env -if ./flut-renamer-nix
```

## Install using generated manifests

These are release attachments, not automatic submissions to Homebrew Cask,
Scoop's public buckets, winget-pkgs, Flathub, Nixpkgs or AUR. Public repository
submissions can be made separately using the generated files.

For Homebrew, put the downloaded `flut-renamer.rb` into a local tap:

```sh
brew tap-new local/flut-renamer
mkdir -p "$(brew --repository local/flut-renamer)/Casks"
cp flut-renamer.rb "$(brew --repository local/flut-renamer)/Casks/"
brew install --cask local/flut-renamer/flut-renamer
```

The DMG retains the existing unsigned build behavior; installing via Homebrew
does not add Apple signing or notarization.

For Scoop, use the downloaded manifest in PowerShell:

```powershell
scoop install .\flut-renamer.json
```

For Winget, enable local manifests (from an elevated terminal if necessary),
then validate and install the downloaded manifest:

```powershell
winget settings --enable LocalManifestFiles
winget validate --manifest .\FlutRenamer.FlutRenamer.yaml
winget install --manifest .\FlutRenamer.FlutRenamer.yaml
```

## Local checks

```sh
python3 -m unittest discover -s packaging -p 'test_*.py'
for script in github_appimage_build.sh packaging/*.sh; do bash -n "$script"; done
```

The Linux packaging scripts require an already-built native Flutter release
bundle. CI installs FPM 1.16.0, RPM tools, libarchive tools, zstd, Flatpak and
AppImage dependencies. `github_appimage_build.sh` verifies the pinned
appimagetool 1.9.1 binary for each CPU before running it.

Linux packaging requires ImageMagick (`convert`). The scripts resize
`assets/desktop.png` to a stripped 256×256 PNG before installing it into the
hicolor icon theme for Flatpak, Deb, RPM, Pacman and Nix. The source image is
preserved. This also keeps Flatpak exports below its 512×512 raster icon limit.

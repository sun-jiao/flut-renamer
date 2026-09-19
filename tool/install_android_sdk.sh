#!/usr/bin/env bash
set -euo pipefail

sdk_root="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
sdk_manager="$sdk_root/cmdline-tools/latest/bin/sdkmanager"
if [[ -z "$sdk_root" || ! -x "$sdk_manager" ]]; then
  echo 'Android command-line tools are missing from the hosted runner.' >&2
  exit 1
fi

# Accept licenses for the requested package only. yes can exit with SIGPIPE
# when the installer finishes; never hide the installer's own failure.
install_with_license_input() {
  local installer_status
  set +o pipefail
  if yes 2>/dev/null | "$@"; then
    installer_status=0
  else
    installer_status=$?
  fi
  set -o pipefail
  return "$installer_status"
}

install_with_license_input "$sdk_manager" --sdk_root="$sdk_root" \
  --channel=0 'cmdline-tools;23.0'

# Tools 23.0's sdkmanager is a compatibility wrapper around Android CLI.
# Use the new interface and slash-separated package ID directly. Do not parse
# its human-readable list output as the legacy pipe-separated SDK table.
android_cli="$sdk_root/cmdline-tools/23.0/bin/android"
if [[ ! -x "$android_cli" ]]; then
  echo 'Command-line tools 23.0 did not install the Android CLI.' >&2
  exit 1
fi
if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "$sdk_root/cmdline-tools/23.0/bin" >> "$GITHUB_PATH"
fi
sdk_package='platforms/android-37.0'
"$android_cli" --version
"$android_cli" --no-metrics --sdk="$sdk_root" sdk list "$sdk_package" \
  | tee integration-sdk-packages.log
install_with_license_input "$android_cli" --no-metrics --sdk="$sdk_root" \
  sdk install "$sdk_package"

# Success requires the installed platform, not a match in a display table.
if [[ ! -f "$sdk_root/platforms/android-37.0/android.jar" ]]; then
  echo 'SDK install returned success but the API 37.0 android.jar is missing.' >&2
  exit 1
fi

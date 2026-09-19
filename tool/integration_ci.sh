#!/usr/bin/env bash
set -euo pipefail

# These tests use native application preferences/logs. Never run this entry
# point on a developer workstation or a persistent self-hosted runner.
if [[ "${GITHUB_ACTIONS:-}" != true || "${RUNNER_ENVIRONMENT:-}" != github-hosted ]]; then
  echo 'This entry point requires a disposable GitHub-hosted runner.' >&2
  exit 2
fi
test_device=${1:?device ID is required}
test_target=${2:?test entry point is required}
test_timeout=${RENAMER_TEST_TIMEOUT:-10m}
if [[ "$test_device" == emulator-* ]]; then
  trap 'adb -s "$test_device" logcat -d > integration-device.log 2>&1 || true' EXIT
fi

run_test() {
  local output_file=$1
  local flutter_args=(
    test "$test_target" -d "$test_device" --no-pub
    --dart-define=RENAMER_CI_TESTS=true
    --timeout "$test_timeout"
    --reporter expanded
  )
  if [[ "${RENAMER_FLUTTER_VERBOSE:-}" == true ]]; then
    flutter_args+=(--verbose)
  fi
  flutter "${flutter_args[@]}" 2>&1 | tee "$output_file"
}

if run_test integration-platform.log; then
  exit 0
else
  test_status=$?
fi

# CoreSimulator's unified-log stream can occasionally fail before the Dart VM
# service is discovered. Retry only a suite that never loaded a single test;
# real test failures must remain failures and must not be hidden by a rerun.
if [[ "${RENAMER_RETRY_IOS_STARTUP:-}" == true \
      && "$test_device" =~ ^[0-9A-Fa-f-]{36}$ \
      && -x "$(command -v xcrun)" \
      && $(grep -cF '+0 -1: loading' integration-platform.log || true) -gt 0 \
      && $(grep -cF 'Error waiting for a debug connection' integration-platform.log || true) -gt 0 ]]; then
  mv integration-platform.log integration-platform-attempt-1.log
  xcrun simctl spawn "$test_device" log show --last 10m --style compact \
    > integration-device-attempt-1.log 2>&1 || true
  xcrun simctl shutdown "$test_device" || true
  xcrun simctl erase "$test_device"
  xcrun simctl boot "$test_device"
  xcrun simctl bootstatus "$test_device" -b
  run_test integration-platform.log
  exit $?
fi

exit "$test_status"

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
flutter test "$test_target" -d "$test_device" --no-pub \
  --dart-define=RENAMER_CI_TESTS=true --timeout "$test_timeout" --reporter expanded \
  2>&1 | tee integration-platform.log

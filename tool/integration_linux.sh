#!/usr/bin/env bash
set -euo pipefail

# Isolate native preferences, rules, logs and test files from everyday app data.
test_sandbox=$(mktemp -d /tmp/renamer-integration.XXXXXXXX)
trap 'rm -rf --one-file-system -- "$test_sandbox"' EXIT
mkdir -p "$test_sandbox/config" "$test_sandbox/cache" "$test_sandbox/data" "$test_sandbox/tmp"
export RENAMER_INTEGRATION_SANDBOX="$test_sandbox"
export XDG_CONFIG_HOME="$test_sandbox/config"
export XDG_CACHE_HOME="$test_sandbox/cache"
export XDG_DATA_HOME="$test_sandbox/data"
export TMPDIR="$test_sandbox/tmp"
# FLUTTER_BIN can bypass distribution wrappers that mount an SDK in XDG cache.
"${FLUTTER_BIN:-flutter}" test integration_test/desktop_test.dart -d linux --reporter expanded "$@"

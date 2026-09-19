# Native Integration Tests

These tests launch actual Flutter application components within the native application process, utilizing real implementations of `path_provider`, `shared_preferences`, file I/O, metadata reading, and atomic renaming. No platform channel mocking is involved. Adding files to the list and creating most rules relies on the application's public APIs; not every use case originates from the system file picker.
The scenarios are categorized into application workflows and cross-platform native contracts; they do not constitute an exhaustive proof covering every possible input and platform combination.

## Execution

Run the following from the project root (requires Flutter, Linux desktop build dependencies, and a graphical session):

```bash
flutter pub get --enforce-lockfile
bash tool/integration_linux.sh
```

For headless Linux/CI environments:

```bash
xvfb-run -a -s '-screen 0 1920x1080x24' bash tool/integration_linux.sh
```

Requires `xvfb` and `xauth`. The script creates dedicated directories for preferences, temporary rules, logs, and test files, and verifies upon startup that paths returned by native plugins are also within these isolated directories. Test data is deleted after completion; production application data is not used. Do not execute `flutter test integration_test` directly, as isolation checks will prevent execution.
If your distribution's `flutter` wrapper mounts the SDK within the XDG cache, specify the actual SDK executable path:

```bash
FLUTTER_BIN=/absolute/path/to/flutter/bin/flutter bash tool/integration_linux.sh
```

Flutter test arguments are supported (e.g., `--plain-name 'real rename: insert'` or `--no-pub`).
The `integration-linux` job in GitHub Actions automatically runs the full suite of scenarios with a 20-minute timeout; the `integration-linux-log` is uploaded regardless of success or failure (retained for 7 days).

## Other Platforms: GitHub Actions

Pushing to `main`, submitting a PR, or manually triggering the `CI` workflow on the Actions page executes the following matrix.
Newly added platforms that have not yet been tested locally rely on the actual results from their respective jobs. | Environment | Test Entry Point | Number of Scenarios | Key Focus |
| --- | --- | --- | --- |
| Linux | `desktop_test.dart` | 45 | 35 application workflows + 10 native contract tests |
| Windows 2022 / x64 | `desktop_test.dart` | 44 | MoveFileExW, case-only renaming, real plugins, full desktop workflows |
| macOS 15 / arm64 | `desktop_test.dart` | 45 | renamex_np, case-only renaming, real plugins, full desktop workflows |
| Android API 29, 35 / x86_64 | `platform_test.dart` | 13 each | Atomic renaming, plugins, move/rename operations, ContentResolver & media write permission requests |
| iOS / arm64 Simulator | `platform_test.dart` | 11 | Atomic renaming, plugins, move/rename operations, scoped-access channel calls |

Dangling symbolic link scenarios are excluded for Windows because creating symbolic links requires Developer Mode or elevated privileges;
"No-replace" tests for standard files and directories must still pass. Desktop-specific UI scenarios are not forced
to run with desktop dimensions on mobile; mobile platforms retain smoke tests for primary operations using real device layouts.

The 10 shared scenarios in `platform_test.dart` verify: native plugin registration and writable directories, preference read/write/delete,
Unicode/case-only renaming, OS error codes on file/directory conflicts, missing source files, filename swapping,
parent-child directory transactions, YAML/log round-trips, and renaming app-private files via the main UI button.
Android file URI tests are not SAF `content://` tests; iOS channel tests do not verify external directory authorization.

`tool/integration_ci.sh` permits only GitHub-hosted ephemeral runners and requires the explicit build flag
`RENAMER_CI_TESTS=true`. These tests modify application preferences, rules, and logs within the ephemeral environment;
do not pass this flag when running on personal devices, daily-use desktops, or persistent self-hosted runners.
GitHub-hosted runners provide built-in isolation, and mobile simulators are created independently for each job.
Test files are stored in a dedicated subdirectory within the application's temporary directory; native contract tests delete this subdirectory during teardown.

- Android: Uses a fresh AVD; API 29 verifies the syscall path when `renameat2` is not exported by libc, while API 35 verifies the path used in newer versions.
- The compile and target SDK remain API 37. Google's stable repository publishes the package as `platforms;android-37.0`, not `platforms;android-37`. CI first installs pinned command-line tools 23.0 to handle the SDK metadata, checks that exact platform package before installing it, retains `integration-sdk-packages.log`, and fails without downgrading if it is missing. Emulator API levels are independent of the compile SDK.
- iOS: Selects the latest version with an iPhone device type from available installed iOS runtimes, creates a dedicated device, and runs tests after startup; cleans up only the UDID created for the job (leaving other simulators untouched). No distribution signing certificate is required.
- Matrix jobs fail independently (no `continue-on-error`); timeouts are set to 35 minutes for desktop, 45 for Android, and 40 for iOS.
- All new jobs upload `integration-<platform>` logs, retained for 7 days; Android collects logcat before shutting down the simulator, while iOS collects system logs upon failure.
- `node --test tool/boot_ios_simulator_test.cjs` verifies the logic for simulator selection and cleanup flags (mocking only the CI control script, not the application's platform channel).

Execution follows the [Flutter integration testing documentation](https://docs.flutter.dev/testing/integration-tests).
Runner types are based on the [GitHub-hosted runners documentation](https://docs.github.com/en/actions/reference/runners/github-hosted-runners).
The minimum macOS version aligns with the 10.15 requirement of the current `shared_preferences_foundation`;
Android error code retrieval uses [bionic's `__errno`](https://android.googlesource.com/platform/bionic/+/master/libc/include/errno.h) to prevent false positives regarding "atomic rename unavailability" in error paths. ## Coverage Matrix

| Category | Scenarios and Key Assertions |
| --- | --- |
| Application + Native File System | Insert, limited replacement, regex capture groups, reverse-order deletion, zero-padded numbering, reordering, truncation, case conversion: preview, commit, content unchanged, old paths removed |
| Filename Boundaries | Unicode, spaces, hidden files, multiple extensions, unsafe character replacement |
| Batch Operations | Empty list, no rules, selected but not active, partial file selection, retain/clear rename rows and rules |
| Conflict Protection | Existing files, existing directories, intra-batch duplicate targets, targets appearing after preview; batch execution aborted, external data unchanged |
| List Interaction | Duplicate additions, case-insensitive filtering, select-all after filtering, remove from list without deleting disk files |
| Preview Consistency | Sequence numbers recalculated upon sorting; random values ​​remain constant between selection changes and commit; accurate modification date metadata |
| Rule Interaction | Add via dialog, edit/update, cancel, delete; preview and persistence remain synchronized after drag-and-drop reordering |
| Storage Integration | YAML round-trip for all rule types, rule recovery upon app remount, fault tolerance for corrupt/missing files; native read-back of preferences |
| Logging | Successful renames written to actual logs; records displayed in the application log dialog |
| Native Transaction Services | Cyclic rename of three files leaves no temporary artifacts; simultaneous renaming of parent directory and child files; dangling symlinks cannot be overwritten |
| Fault Recovery | Actual file moves combined with controlled fault injection; verify successful rollback and path rescanning after rollback failure; rollback after source file disappears during commit |

Each scenario uses a dedicated file directory; failure paths assert both original content and target paths, rather than merely checking error prompts.
Each test is limited to 2 minutes with bounded status polling. Remount tests involve component reconstruction within the same process,
not a process restart following system termination; YAML round-trip testing is distinct from system import/export picker tests. Test cases involving missing source files or symbolic link conflicts will produce expected `FileSystemException` debug output;
pass/fail status is determined by the test suite results, though the tests still verify return values ​​and disk contents.

## Scenarios Requiring Verification in Other Environments

The following scenarios are not "theoretically untestable" but cannot be covered by the current Flutter test driver or selected scenarios;
they require physical devices, OS-level automation, or manual acceptance testing. This suite must not be used as a substitute
for platform-specific acceptance testing for:

- Android SAF/MediaStore, permission grant/deny/revocation, and third-party document providers; current coverage is limited to API 29/35 and does not encompass all versions or ARM physical devices.
- iOS/macOS security-scoped bookmarks, sandbox authorization lifecycles, and system file picker/sharing interfaces.
- Windows/macOS locked files, reserved names, path limitations, and network volumes; current verification is limited to the renaming semantics of the default local file system on the chosen runner.
- System picker actions (selection/cancellation/import/export), cross-app drag-and-drop, opening links, and store redirects.
- App cold starts/command-line arguments, recovery after forced termination or power loss, real-world disk full/disconnection/permission changes, and multi-process contention.
- All sorting fields and reverse sorting, all combinations of rule parameters, performance with massive batches, and combinations of languages, screen sizes, and screen readers.

Fine-grained combinations of rule parameters and invalid inputs continue to be covered by `test/` unit and widget tests.
It is impossible to exhaustively test every combination of timing, OS/file system, and input; real-world regression cases should be continuously added to the test matrix.

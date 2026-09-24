# Apple platform verification

The iOS runner uses Flutter's UIScene lifecycle and registers its picker channel
in `didInitializeImplicitFlutterEngine`. macOS requires 12.0 or later, matching
the Flutter 3.47 toolchain used in CI.

## Automated checks

- Run `flutter analyze` and `flutter test` on the development host.
- The existing `integration-ios` CI job compiles the Swift runner and runs
  `integration_test/platform_test.dart` on a simulator. The atomic rename tests
  now exercise the native coordinated-rename channel on iOS, including Unicode,
  case-only renames, destination conflicts, swaps, and parent/child transactions.
- The iOS scope tests check private-container access, rejection of an unselected
  external path, and idempotent cleanup. They do not obtain an external grant.
- Existing macOS CI builds/tests verify the deployment-target and runner changes.

Linux analysis and mocked channel tests cannot compile Swift or validate TCC,
external security-scoped URLs, document-provider behavior, or picker presentation.

## Device/provider verification

Use disposable files for these cases, with both local Files storage and iCloud
Drive (and a third-party provider if supported):

1. Select a folder, then select files inside it and in a nested folder. Rename
   them, including a case-only change and an existing destination conflict.
2. Cancel either picker, including interactive dismissal. Reopen immediately.
3. Navigate outside the authorized folder in the second picker. Expect a clear
   error asking to select that folder first, without adding inaccessible rows.
4. Add multiple files from one folder, remove one, and rename a remaining file.
   Clear the list, then select the folder again. Repeat selection and cancellation.
5. Rename and remove all rows from one folder while another folder still has
   rows. The remaining folder must stay usable.
6. Revoke folder permission in Settings and retry. The app must report a failure,
   not claim success. Re-select the folder to recover.
7. Background and foreground the app before reopening the picker; verify that
   the picker is attached to the active Flutter scene.
8. On macOS, start without Full Disk Access. Startup should not prompt based on
   a TCC-directory probe. Test renaming user-selected files and an actual denied
   path separately.

The folder grants intentionally last only for the current process; no persistent
bookmarks are stored. The file list is process-wide, so switching Flutter pages
must not revoke grants for rows that remain in that list.

The native coordination added here covers renames. Existing Dart metadata and
thumbnail readers still read paths directly; fully coordinating those reads or
materializing cloud-only content is a separate integration concern and is not
proved by the private-directory tests.

## Official references

- [Flutter UIScene migration](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate)
- [Flutter supported platforms](https://docs.flutter.dev/reference/supported-platforms)
- [Apple directory access](https://developer.apple.com/documentation/uikit/providing-access-to-directories)
- [Apple security-scoped resource access](https://developer.apple.com/documentation/foundation/url/startaccessingsecurityscopedresource%28%29)
- [Apple coordinated move notification](https://developer.apple.com/documentation/foundation/nsfilecoordinator/item%28at%3Adidmoveto%3A%29)
- [Apple file system permissions](https://developer.apple.com/forums/thread/678819)

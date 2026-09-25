# Haptic feedback

Mobile haptics are enabled by default. The **Haptic feedback** option in the
bottom toolbar's options can disable them; the preference survives restarts.
The option is hidden on desktop. Feedback is suppressed while the app is not
resumed, and unavailable platform support never fails a file operation.

| Interaction | Feedback |
| --- | --- |
| Start dragging a file or rule | One light impact |
| Change a file selection | One selection click |
| Select or deselect all | One selection click for the whole action |
| Finish a batch with at least one changed name | One success notification |
| Reject an invalid rename plan | One error notification on explicit execution |
| Fail a transaction | One error notification after rollback/rescanning |

Preview updates, empty/unchanged batches, selection of an empty list, and
cancelled media-write authorization do not emit feedback. A cancelled or stale
operation does not report success. Existing visual errors remain authoritative.

`AppHaptics` uses Flutter's built-in `HapticFeedback` API (available in the
project's minimum Flutter 3.44). No plugin, native code, or vibration permission
is added. Android's native touch feedback respects system settings. Flutter's
success/error notifications require Android API 30 or later; on older Android
versions they silently do nothing. Hardware and OS settings determine whether
a supported call is physically felt. Desktop and web calls are skipped.

## Validation

Automated tests cover the platform channel, preference persistence, foreground
and platform guards, missing support, actual selection/drag gestures, and
batch success, no-op, collision, and rollback behavior using temporary files.

Before release, check on physical Android and iOS devices:

- Drag files and rules, toggle individual selections, and select all. Each
  interaction should feel brief; selecting all must not vibrate per file.
- Disable the app option, restart, and repeat. Turn it back on and repeat.
- On Android, disable system touch feedback and verify it remains silent.
- Execute a multi-file rename, a no-op batch, and a conflicting batch. Confirm
  that result feedback agrees with the visible result and happens once.
- Cancel Android media-write authorization and verify there is no success
  feedback. Background the app during a batch and verify completion is silent.

Automated channel tests cannot verify motor strength or perceived timing.

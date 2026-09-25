import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../entity/sharedpref.dart';

/// Optional UI feedback. It must never affect the outcome of a file operation.
abstract final class AppHaptics {
  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static Future<void> dragStarted() => _play(HapticFeedback.lightImpact);
  static Future<void> selectionChanged() =>
      _play(HapticFeedback.selectionClick);
  static Future<void> success() => _play(HapticFeedback.successNotification);
  static Future<void> error() => _play(HapticFeedback.errorNotification);

  static Future<void> _play(Future<void> Function() feedback) async {
    if (!supported || !Shared.hapticFeedback) return;
    final state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) return;
    try {
      await feedback();
    } on MissingPluginException {
      // Hosts without haptic support simply remain silent.
    } on PlatformException catch (error) {
      debugPrint('Unable to play haptic feedback: $error');
    }
  }
}

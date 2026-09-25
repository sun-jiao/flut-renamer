import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/tools/app_haptics.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <MethodCall>[];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Shared.init();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    calls.clear();
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  test('uses semantic native feedback on both mobile platforms', () async {
    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      debugDefaultTargetPlatformOverride = platform;
      calls.clear();
      await AppHaptics.dragStarted();
      await AppHaptics.selectionChanged();
      await AppHaptics.success();
      await AppHaptics.error();
      expect(
        calls.map((call) => call.method),
        everyElement('HapticFeedback.vibrate'),
      );
      expect(calls.map((call) => call.arguments), [
        'HapticFeedbackType.lightImpact',
        'HapticFeedbackType.selectionClick',
        'HapticFeedbackType.successNotification',
        'HapticFeedbackType.errorNotification',
      ]);
    }
  });

  test('disabled, desktop and background feedback remain silent', () async {
    Future<void> playAll() async {
      await AppHaptics.dragStarted();
      await AppHaptics.selectionChanged();
      await AppHaptics.success();
      await AppHaptics.error();
    }

    Shared.hapticFeedback = false;
    await playAll();
    Shared.hapticFeedback = true;
    for (final platform in [
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      await playAll();
    }
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await playAll();
    expect(calls, isEmpty);
  });

  test('missing support and platform errors never escape', () async {
    for (final error in [
      MissingPluginException(),
      PlatformException(code: 'unavailable'),
    ]) {
      binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (_) async => throw error,
      );
      await expectLater(AppHaptics.success(), completes);
    }
  });
}

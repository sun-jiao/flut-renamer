import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/pages/home_page.dart';
import 'package:flut_renamer/pages/rules_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final feedback = <String>[];
  late Directory directory;
  late GlobalKey<FilesPageState> key;

  setUp(() async {
    await L10n.load(const Locale('en'));
    SharedPreferences.setMockInitialValues({});
    await Shared.init();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    directory = Directory.systemTemp.createTempSync('renamer-haptics-');
    key = GlobalKey<FilesPageState>();
    feedback.clear();
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => directory.path,
    );
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          feedback.add(call.arguments as String);
        }
        return null;
      },
    );
  });

  tearDown(() async {
    await Logger().flush();
    debugDefaultTargetPlatformOverride = null;
    binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    directory.deleteSync(recursive: true);
  });

  Future<void> settleFiles(WidgetTester tester) async {
    // Filesystem checks need real event-loop turns; pumping only the fake
    // clock leaves the preview progress indicators animating indefinitely.
    for (var attempt = 0; attempt < 100; attempt++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),);
      await tester.pump(const Duration(milliseconds: 100));
      if (!binding.hasScheduledFrame) return;
    }
    fail('File previews did not settle');
  }

  Future<void> showFiles(
    WidgetTester tester, {
    int count = 2,
    String Function(String)? newName,
  }) async {
    FilesPage.addFiles(List.generate(count, (index) {
      final file = File('${directory.path}/$index.txt')
        ..writeAsStringSync('$index');
      return FileEntity(file);
    }),);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            FileListColors(
              primaryColor: Colors.white,
              secondaryColor: Colors.grey.shade100,
            ),
          ],),
          home: Scaffold(
            body: FilesPage(
              key: key,
              getNewName: (name, _) => newName?.call(name) ?? name,
              clearRules: () {},
              resetRules: () {},
              dependsOnFileOrder: () => false,
              requiresMetadata: () => false,
            ),
          ),
        ),
      );
    });
    await settleFiles(tester);
  }

  Future<void> clearFiles(WidgetTester tester) async {
    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  }

  testWidgets('selection, select-all and drag each emit one feedback',
      (tester) async {
    await showFiles(tester);
    expect(feedback, isEmpty); // Building and generating previews stay silent.
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    expect(feedback, ['HapticFeedbackType.selectionClick']);
    feedback.clear();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(feedback, ['HapticFeedbackType.selectionClick']);
    expect(
      tester.widgetList<Checkbox>(find.byType(Checkbox)).map((c) => c.value),
      everyElement(isTrue),
    );
    feedback.clear();
    await tester.drag(
        find.byIcon(Icons.drag_handle).first, const Offset(0, 60),);
    await tester.pumpAndSettle();
    expect(feedback, ['HapticFeedbackType.lightImpact']);

    Shared.hapticFeedback = false;
    feedback.clear();
    await tester.tap(find.byType(Checkbox).first);
    await tester.drag(
        find.byIcon(Icons.drag_handle).first, const Offset(0, 60),);
    await tester.pumpAndSettle();
    expect(feedback, isEmpty);
    await clearFiles(tester);
    await showFiles(tester, count: 0);
    Shared.hapticFeedback = true;
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(feedback, isEmpty);
    await clearFiles(tester);
  });

  testWidgets('rule dragging respects the haptic preference', (tester) async {
    final rulesKey = GlobalKey<RulesPageState>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: RulesPage(key: rulesKey, onRuleChanged: () {})),
    ),);
    await settleFiles(tester);
    rulesKey.currentState!.addRule(RuleInsert('first-', 0, false, false, true));
    rulesKey.currentState!
        .addRule(RuleInsert('second-', 0, false, false, true));
    await settleFiles(tester);
    expect(feedback, isEmpty);
    await tester.drag(
        find.byIcon(Icons.drag_handle).first, const Offset(0, 80),);
    await settleFiles(tester);
    expect(feedback, ['HapticFeedbackType.lightImpact']);
    Shared.hapticFeedback = false;
    feedback.clear();
    await tester.drag(
        find.byIcon(Icons.drag_handle).first, const Offset(0, 80),);
    await settleFiles(tester);
    expect(feedback, isEmpty);
    Shared.removeRules = true;
    rulesKey.currentState!.clearRule();
    await settleFiles(tester);
    await tester.pumpWidget(const SizedBox());
  });

  for (final scenario in [
    'success',
    'unchanged',
    'empty',
    'unselected',
    'collision',
    'rollback',
  ]) {
    testWidgets('batch feedback: $scenario', (tester) async {
      tester.view.physicalSize = const Size(1600, 3200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      if (scenario == 'collision') {
        File('${directory.path}/new-0.txt').writeAsStringSync('external');
      }
      await showFiles(
        tester,
        count: scenario == 'empty' ? 0 : 2,
        newName: (name) => scenario == 'unchanged' ? name : 'new-$name',
      );
      expect(feedback, isEmpty);
      if (scenario == 'rollback') {
        // The second source disappears after preview. The first rename must
        // be rolled back before the page reports the failed batch.
        File('${directory.path}/1.txt').deleteSync();
      }
      await tester.runAsync(() async {
        await key.currentState!.renameFiles(
          remove: false,
          onlySelected: scenario == 'unselected',
        );
        await Logger().flush();
      });
      expect(
          feedback,
          switch (scenario) {
            'success' => ['HapticFeedbackType.successNotification'],
            'collision' || 'rollback' => [
                'HapticFeedbackType.errorNotification',
              ],
            _ => isEmpty,
          },);
      if (scenario == 'success') {
        expect(File('${directory.path}/new-0.txt').readAsStringSync(), '0');
        expect(File('${directory.path}/new-1.txt').readAsStringSync(), '1');
      } else if (scenario == 'rollback') {
        expect(File('${directory.path}/0.txt').readAsStringSync(), '0');
        expect(File('${directory.path}/new-0.txt').existsSync(), isFalse);
      }
      // A failed native rename also opens the existing error dialog.
      await settleFiles(tester);
      if (find.byType(Dialog).evaluate().isNotEmpty) {
        Navigator.of(tester.element(find.byType(Dialog))).pop();
        await settleFiles(tester);
      }
      await clearFiles(tester);
    });
  }

  testWidgets('haptic option persists and is hidden on desktop',
      (tester) async {
    tester.view.physicalSize = const Size(1800, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Widget toolbar() => MaterialApp(
          home: Scaffold(
              bottomNavigationBar: HomeToolBar(
            hapticFeedbackCallback: (value) => Shared.hapticFeedback = value,
            hapticFeedbackValue: () => Shared.hapticFeedback,
            showThumbnailsCallback: (_) {},
            showThumbnailsValue: () => false,
            onlySelectedCallback: (_) {},
            onlySelectedValue: () => false,
            removeRenamedCallback: (_) {},
            removeRenamedValue: () => true,
            removeRulesCallback: (_) {},
            removeRulesValue: () => false,
          ),),
        );
    await tester.pumpWidget(toolbar());
    final option = find.widgetWithText(FilterChip, L10n.current.hapticFeedback);
    expect(tester.widget<FilterChip>(option).selected, isTrue);
    await tester.tap(option);
    await tester.pump();
    await Shared.init();
    expect(Shared.hapticFeedback, isFalse);
    expect(tester.widget<FilterChip>(option).selected, isFalse);
    expect(feedback, isEmpty);
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    await tester.pumpWidget(toolbar());
    expect(option, findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });
}

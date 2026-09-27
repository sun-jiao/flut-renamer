import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/rules_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/rule_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('rules_drop_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => directory.path);
    await L10n.load(const Locale('en'));
    SharedPreferences.setMockInitialValues({'remove_rules': true});
    await Shared.init();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    directory.deleteSync(recursive: true);
  });

  for (final mode in [
    'before',
    'after',
    'replace',
    'cancel',
    'invalid',
    'other',
  ]) {
    testWidgets('dropping rules: $mode', (tester) async {
      final key = GlobalKey<RulesPageState>();
      var changes = 0;
      final existing = RuleInsert('existing', 0, false, false, true);
      final first = RuleInsert('first', 0, false, false, true);
      final second = RuleInsert('second', 0, false, false, true);
      final source =
          File('${directory.path}/rules.${mode == 'other' ? 'txt' : 'YAML'}');
      await tester.runAsync(
        () => RulePersistence.saveRules([first, second], targetFile: source),
      );
      if (mode == 'invalid') source.writeAsStringSync('not: [valid');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RulesPage(key: key, onRuleChanged: () => changes++),
          ),
        ),
      );
      await tester.runAsync(() async {
        // Finish the initial cache read before populating the current rules.
        await Future<void>.delayed(const Duration(milliseconds: 30));
        key.currentState!.clearRule();
        key.currentState!.addRule(existing);
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pumpAndSettle();
      changes = 0;
      final target = tester.widget<DropTarget>(find.byType(DropTarget));
      await tester.runAsync(() async {
        target.onDragDone!(
          DropDoneDetails(
            files: [DropItemFile(source.path)],
            localPosition: Offset.zero,
            globalPosition: Offset.zero,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pumpAndSettle();
      if (mode == 'invalid' || mode == 'other') {
        expect(find.byType(SimpleDialog), findsNothing);
        if (mode == 'invalid') {
          expect(find.text(L10n.current.noValidRules), findsOneWidget);
        }
      } else {
        expect(find.text(L10n.current.importRulesBefore), findsOneWidget);
        expect(find.text(L10n.current.importRulesAfter), findsOneWidget);
        expect(find.text(L10n.current.importRulesReplace), findsOneWidget);
        expect(key.currentState!.rules, [existing]);
        final label = {
          'before': L10n.current.importRulesBefore,
          'after': L10n.current.importRulesAfter,
          'replace': L10n.current.importRulesReplace,
          'cancel': L10n.current.cancel,
        }[mode]!;
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pumpAndSettle();
      final expected = switch (mode) {
        'before' => [first, second, existing],
        'after' => [existing, first, second],
        'replace' => [first, second],
        _ => [existing],
      };
      expect(
        key.currentState!.rules.map((r) => r.toMap()),
        expected.map((r) => r.toMap()),
      );
      expect(changes, ['before', 'after', 'replace'].contains(mode) ? 1 : 0);
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        final saved = await RulePersistence.loadRules();
        expect(saved.map((r) => r.toMap()), expected.map((r) => r.toMap()));
      });
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}

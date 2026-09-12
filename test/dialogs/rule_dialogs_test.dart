import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/dialogs/insert_dialog.dart';
import 'package:flut_renamer/dialogs/rearrange_dialog.dart';
import 'package:flut_renamer/dialogs/replace_dialog.dart';
import 'package:flut_renamer/dialogs/truncate_dialog.dart';
import 'package:flut_renamer/dialogs/transliterate_dialog.dart';
import 'package:flut_renamer/entity/transliterate.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => L10n.load(const Locale('en')));

  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('ReplaceDialog saves edited options into a replace rule',
      (tester) async {
    RuleReplace? saved;
    await tester.pumpWidget(host(ReplaceDialog(
      remove: false,
      onSave: (rule) => saved = rule as RuleReplace,
    )));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'old');
    await tester.enterText(fields.at(1), 'new');
    await tester.enterText(fields.at(2), '2');
    final caseSensitive = find.byType(Checkbox).at(2);
    final regex = find.byType(Checkbox).at(3);
    await tester.ensureVisible(caseSensitive);
    await tester.tap(caseSensitive);
    await tester.ensureVisible(regex);
    await tester.tap(regex);
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(saved?.targetString, 'old');
    expect(saved?.replacementString, 'new');
    expect(saved?.replaceLimit, 2);
    expect(saved?.caseSensitive, isTrue);
    expect(saved?.isRegex, isTrue);
  });

  testWidgets('ReplaceDialog saves remove-mode options into a remove rule',
      (tester) async {
    RuleRemove? saved;
    final existing = RuleRemove('draft', -3, true, true, false);
    await tester.pumpWidget(host(ReplaceDialog(
      remove: true,
      rule: existing.ruleReplace,
      onSave: (rule) => saved = rule as RuleRemove,
    )));

    final fields = find.byType(TextFormField);
    expect(
        tester.widget<TextFormField>(fields.at(0)).controller!.text, 'draft');
    expect(tester.widget<TextFormField>(fields.at(1)).controller!.text, '3');
    await tester.enterText(fields.at(0), 'tmp');
    await tester.enterText(fields.at(1), '2');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(saved?.targetString, 'tmp');
    expect(saved?.ruleReplace.replaceLimit, -2);
    expect(saved?.ruleReplace.caseSensitive, isTrue);
    expect(saved?.ruleReplace.isRegex, isTrue);
    expect(saved?.ruleReplace.ignoreExtension, isFalse);
  });

  testWidgets('RearrangeDialog restores an existing rule and saves edits',
      (tester) async {
    RuleRearrange? saved;
    await tester.pumpWidget(host(RearrangeDialog(
      rule: RuleRearrange('-', [3, 2, 1], true),
      onSave: (rule) => saved = rule as RuleRearrange,
    )));

    final fields = find.byType(TextFormField);
    expect(tester.widget<TextFormField>(fields.at(0)).controller!.text, '-');
    expect(
        tester.widget<TextFormField>(fields.at(1)).controller!.text, '3,2,1');
    await tester.enterText(fields.at(0), '_');
    await tester.enterText(fields.at(1), '2,1');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(saved?.delimiter, '_');
    expect(saved?.order, [2, 1]);
    expect(saved?.ignoreExtension, isTrue);
  });

  testWidgets(
      'ReplaceDialog exposes one valid date-format selector for metadata',
      (tester) async {
    await tester.pumpWidget(host(const ReplaceDialog(
      remove: false,
      onSave: _ignoreRule,
    )));

    final metadata = find.byType(Checkbox).at(1);
    await tester.ensureVisible(metadata);
    await tester.tap(metadata);
    await tester.pump();

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });

  testWidgets('InsertDialog saves text, index, and existing options',
      (tester) async {
    RuleInsert? saved;
    await tester.pumpWidget(host(InsertDialog(
      rule: RuleInsert('old', 3, true, false, false),
      onSave: (rule) => saved = rule as RuleInsert,
    )));

    final fields = find.byType(TextFormField);
    expect(tester.widget<TextFormField>(fields.at(0)).controller!.text, 'old');
    await tester.enterText(fields.at(0), 'prefix-');
    await tester.enterText(fields.at(1), '5');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(saved?.insert, 'prefix-');
    expect(saved?.insertIndex, 5);
    expect(saved?.toEnd, isTrue);
    expect(saved?.ignoreExtension, isFalse);
  });

  testWidgets('TruncateDialog saves restored range settings', (tester) async {
    RuleTruncate? saved;
    await tester.pumpWidget(host(TruncateDialog(
      rule: RuleTruncate(2, 4, true, false, false, false),
      onSave: (rule) => saved = rule as RuleTruncate,
    )));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '1');
    await tester.enterText(fields.at(1), '3');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(saved?.index1, 1);
    expect(saved?.index2, 3);
    expect(saved?.i1toEnd, isTrue);
    expect(saved?.keepBetween, isFalse);
    expect(saved?.ignoreExtension, isFalse);
  });

  testWidgets('TransliterateDialog restores and saves the selected type',
      (tester) async {
    RuleTransliterate? saved;
    await tester.pumpWidget(host(TransliterateDialog(
      rule: RuleTransliterate(Transliterate.pinyin),
      onSave: (rule) => saved = rule as RuleTransliterate,
    )));

    expect(find.text(L10n.current.transliteratePinyin), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(saved?.type, Transliterate.pinyin);
  });
}

void _ignoreRule(Rule _) {}

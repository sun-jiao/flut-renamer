import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/dialogs/increment_dialog.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/rule_persistence.dart';

void main() {
  setUpAll(() => L10n.load(const Locale('en')));

  RuleIncrement insert({
    int position = 0,
    bool toEnd = false,
    bool ignoreExtension = true,
  }) =>
      RuleIncrement(
        '[',
        9,
        1,
        false,
        ignoreExtension,
        minimumDigits: 3,
        mode: IncrementMode.insert,
        insertIndex: position,
        toEnd: toEnd,
        suffix: '] ',
      );

  test('inserts affixes and padded sequence, and resets reproducibly',
      () async {
    final rule = insert();
    expect(await rule.newName('photo.jpg'), '[009] photo.jpg');
    expect(await rule.newName('other.jpg'), '[010] other.jpg');
    rule.indexReset();
    expect(await rule.newName('other.jpg'), '[009] other.jpg');
    expect(await rule.newName('photo.jpg'), '[010] photo.jpg');
  });

  test('positions count from either end and clamp to filename bounds',
      () async {
    expect(await insert(position: 2).newName('photo.jpg'), 'ph[009] oto.jpg');
    expect(
      await insert(position: 2, toEnd: true).newName('photo.jpg'),
      'pho[009] to.jpg',
    );
    expect(await insert(toEnd: true).newName('photo.jpg'), 'photo[009] .jpg');
    expect(await insert(position: 99).newName('photo.jpg'), 'photo[009] .jpg');
    expect(
      await insert(position: 99, toEnd: true).newName('photo.jpg'),
      '[009] photo.jpg',
    );
    expect(
      await insert(toEnd: true, ignoreExtension: false).newName('a.jpg'),
      'a.jpg[009] ',
    );
    expect(await insert().newName(''), '[009] ');
    expect(await insert(toEnd: true).newName('.hidden'), '.hidden[009] ');
  });

  test('positions preserve emoji and combining characters', () async {
    expect(
      await insert(position: 1).newName('👨‍👩‍👧‍👦e\u0301.jpg'),
      '👨‍👩‍👧‍👦[009] e\u0301.jpg',
    );
    expect(
      await insert(position: 1, toEnd: true).newName('👨‍👩‍👧‍👦e\u0301.jpg'),
      '👨‍👩‍👧‍👦[009] e\u0301.jpg',
    );
  });

  test('legacy maps keep replacement behavior and new maps round trip',
      () async {
    final legacy = RuleFactory.fromMap({
      'type': 'Increment',
      'prefix': 'Photo',
      'startIndex': 1,
      'step': 1,
      'omitDash': false,
      'ignoreExtension': true,
    }) as RuleIncrement;
    expect(legacy.mode, IncrementMode.replace);
    expect(await legacy.newName('old.jpg'), 'Photo-1.jpg');
    final original = insert(position: 2, toEnd: true);
    await original.newName('first.jpg');
    final restored = RuleFactory.fromMap(original.toMap()) as RuleIncrement;
    expect(restored.toMap(), original.toMap());
    expect(await restored.newName('photo.jpg'), 'pho[009] to.jpg');
    for (final invalid in <String, dynamic>{
      'mode': 'unknown',
      'insertIndex': -1,
      'suffix': 5,
      'toEnd': 'true',
    }.entries) {
      expect(
        RuleFactory.fromMap(
          {...original.toMap(), invalid.key: invalid.value},
        ),
        isNull,
      );
    }
    final replacement =
        RuleIncrement('Photo', 1, 1, false, true, suffix: '_edit');
    expect(await replacement.newName('old.jpg'), 'Photo-1_edit.jpg');
  });

  test('insertion options survive YAML export and import', () async {
    final directory =
        await Directory.systemTemp.createTemp('increment_insert_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/rules.yaml');
    final rule = insert(position: 2, toEnd: true);
    await RulePersistence.saveRules([rule], targetFile: file);
    final restored = await RulePersistence.loadRules(sourceFile: file);
    expect(restored.single.toMap(), rule.toMap());
    expect(await restored.single.newName('photo.jpg'), 'pho[009] to.jpg');
  });

  testWidgets('switches to insertion, saves options, and restores for editing',
      (tester) async {
    RuleIncrement? saved;
    Widget dialog(RuleIncrement? rule) => MaterialApp(
          home: Scaffold(
            body: IncrementDialog(
              rule: rule,
              onSave: (value) => saved = value as RuleIncrement,
            ),
          ),
        );
    await tester.pumpWidget(dialog(null));
    await tester.tap(find.byType(DropdownButtonFormField<IncrementMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(L10n.current.insertIntoOriginalName).last);
    await tester.pumpAndSettle();
    Finder field(String label) => find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.labelText == label,
        );
    await tester.enterText(field(L10n.current.numberPrefix), '[');
    await tester.enterText(field(L10n.current.numberSuffix), '] ');
    await tester.enterText(field(L10n.current.insertIndex), '2');
    await tester.ensureVisible(find.text(L10n.current.toLast));
    await tester.tap(find.text(L10n.current.toLast));
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();
    expect(saved!.mode, IncrementMode.insert);
    expect(saved!.insertIndex, 2);
    expect(saved!.toEnd, isTrue);
    expect(await saved!.newName('photo.jpg'), 'pho[0] to.jpg');
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(dialog(saved));
    expect(
      tester
          .widget<TextField>(field(L10n.current.numberPrefix))
          .controller!
          .text,
      '[',
    );
    expect(
      tester
          .widget<TextField>(field(L10n.current.numberSuffix))
          .controller!
          .text,
      '] ',
    );
    expect(
      tester
          .widget<TextField>(field(L10n.current.insertIndex))
          .controller!
          .text,
      '2',
    );
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();
    expect(saved!.toEnd, isTrue);
    expect(await saved!.newName('photo.jpg'), 'pho[0] to.jpg');
  });
}

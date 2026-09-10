library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/dialogs/increment_dialog.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  test('increments with the selected minimum digit count', () async {
    final rule = RuleIncrement(
      'Photo',
      9,
      1,
      false,
      true,
      minimumDigits: 4,
    );

    expect(await rule.newName('first.jpg'), 'Photo-0009.jpg');
    expect(await rule.newName('second.jpg'), 'Photo-0010.jpg');

    rule.index = 99;
    expect(await rule.newName('third.jpg'), 'Photo-0099.jpg');
    expect(await rule.newName('fourth.jpg'), 'Photo-0100.jpg');
  });

  test('expands naturally once the requested width is exceeded', () async {
    final rule = RuleIncrement(
      'Photo',
      9999,
      1,
      false,
      true,
      minimumDigits: 4,
    );

    expect(await rule.newName('first.jpg'), 'Photo-9999.jpg');
    expect(await rule.newName('second.jpg'), 'Photo-10000.jpg');
  });

  testWidgets(
      'saves a number of digits chosen independently of the start index',
      (tester) async {
    await L10n.load(const Locale('en'));
    await initializeDateFormatting('en');
    RuleIncrement? savedRule;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IncrementDialog(
            onSave: (rule) => savedRule = rule as RuleIncrement,
            rule: null,
          ),
        ),
      ),
    );

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Photo');
    await tester.enterText(fields.at(1), '9');
    await tester.enterText(fields.at(2), '4');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();

    expect(savedRule?.startIndex, 9);
    expect(savedRule?.minimumDigits, 4);
    expect(await savedRule?.newName('photo.jpg'), 'Photo-0009.jpg');
  });
}

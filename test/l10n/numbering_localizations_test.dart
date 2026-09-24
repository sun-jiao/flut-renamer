import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/dialogs/increment_dialog.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  for (final locale in L10n.delegate.supportedLocales) {
    testWidgets(
        'numbering translations and mobile layout: ${locale.languageCode}',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final arb = jsonDecode(
        File('lib/arb/intl_${locale.languageCode}.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      final messages = await L10n.load(locale);
      final values = {
        'numberingMode': messages.numberingMode,
        'replaceOriginalName': messages.replaceOriginalName,
        'insertIntoOriginalName': messages.insertIntoOriginalName,
        'descriptionInsertNumber': messages.descriptionInsertNumber,
        'numberPrefix': messages.numberPrefix,
        'numberSuffix': messages.numberSuffix,
        'numberPositionHint': messages.numberPositionHint,
      };
      for (final entry in values.entries) {
        expect(arb[entry.key], isA<String>());
        expect(entry.value, isNotEmpty);
        expect(entry.value, arb[entry.key]);
      }
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          supportedLocales: L10n.delegate.supportedLocales,
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: IncrementDialog(
              rule: RuleIncrement(
                '',
                1,
                1,
                true,
                true,
                mode: IncrementMode.insert,
              ),
              onSave: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(DropdownButtonFormField<IncrementMode>));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(messages.replaceOriginalName), findsOneWidget);
    });
  }
}

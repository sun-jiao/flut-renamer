import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await L10n.load(const Locale('en'));
  });

  testWidgets('updates every rename option from its filter chip',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var onlySelected = false;
    var removeRenamed = true;
    var removeRules = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: HomeToolBar(
            onlySelectedCallback: (value) => onlySelected = value,
            onlySelectedValue: () => onlySelected,
            removeRenamedCallback: (value) => removeRenamed = value,
            removeRenamedValue: () => removeRenamed,
            removeRulesCallback: (value) => removeRules = value,
            removeRulesValue: () => removeRules,
          ),
        ),
      ),
    );

    await tester.tap(
      find.widgetWithText(FilterChip, L10n.current.onlySelected),
    );
    await tester.pump();
    expect(onlySelected, isTrue);

    await tester.tap(
      find.widgetWithText(FilterChip, L10n.current.removeRenamed),
    );
    await tester.pump();
    expect(removeRenamed, isFalse);

    await tester.tap(
      find.widgetWithText(FilterChip, L10n.current.removeRules),
    );
    await tester.pump();
    expect(removeRules, isTrue);
  });
}

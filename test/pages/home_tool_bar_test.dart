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

    final onlySelectedChip =
        find.widgetWithText(FilterChip, L10n.current.onlySelected);
    await tester.drag(find.byType(ListView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    await tester.tap(onlySelectedChip);
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

  testWidgets('expands and collapses mobile options', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: HomeToolBar(
            onlySelectedCallback: (_) {},
            onlySelectedValue: () => false,
            removeRenamedCallback: (_) {},
            removeRenamedValue: () => true,
            removeRulesCallback: (_) {},
            removeRulesValue: () => false,
          ),
        ),
      ),
    );

    expect(find.text(L10n.current.onlySelected), findsNothing);
    await tester.tap(find.byTooltip(L10n.current.expandOptions));
    await tester.pump();
    expect(find.text(L10n.current.onlySelected), findsOneWidget);

    await tester.tap(find.byTooltip(L10n.current.collapseOptions));
    await tester.pump();
    expect(find.text(L10n.current.onlySelected), findsNothing);
  });
}

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

    var removeRenamed = true;
    var removeRules = false;
    var showThumbnails = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: HomeToolBar(
            hapticFeedbackCallback: (_) {},
            hapticFeedbackValue: () => true,
            showThumbnailsCallback: (value) => showThumbnails = value,
            showThumbnailsValue: () => showThumbnails,
            removeRenamedCallback: (value) => removeRenamed = value,
            removeRenamedValue: () => removeRenamed,
            removeRulesCallback: (value) => removeRules = value,
            removeRulesValue: () => removeRules,
          ),
        ),
      ),
    );

    final thumbnailButton = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && widget.tooltip == L10n.current.showThumbnails,
    );
    expect(tester.widget<IconButton>(thumbnailButton).isSelected, isFalse);
    await tester.tap(thumbnailButton);
    await tester.pump();
    expect(showThumbnails, isTrue);
    expect(tester.widget<IconButton>(thumbnailButton).isSelected, isTrue);

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
            hapticFeedbackCallback: (_) {},
            hapticFeedbackValue: () => true,
            showThumbnailsCallback: (_) {},
            showThumbnailsValue: () => false,
            removeRenamedCallback: (_) {},
            removeRenamedValue: () => true,
            removeRulesCallback: (_) {},
            removeRulesValue: () => false,
          ),
        ),
      ),
    );

    expect(find.byTooltip(L10n.current.showThumbnails), findsOneWidget);
    expect(find.text(L10n.current.removeRenamed), findsNothing);
    await tester.tap(find.byTooltip(L10n.current.expandOptions));
    await tester.pump();
    expect(find.text(L10n.current.removeRenamed), findsOneWidget);

    await tester.tap(find.byTooltip(L10n.current.collapseOptions));
    await tester.pump();
    expect(find.text(L10n.current.removeRenamed), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/dialogs/metadata_dialog.dart';
import 'package:flut_renamer/l10n/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await L10n.load(const Locale('en'));
  });

  testWidgets('lists the photo direction metadata tag', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MetadataDialog(onInsert: _ignore))),
    );

    await tester.scrollUntilVisible(
      find.text('Photo:Direction'),
      200,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('Photo:Direction'), findsOneWidget);
    expect(find.text('Photo direction from exif'), findsOneWidget);
  });
}

void _ignore(String _) {}

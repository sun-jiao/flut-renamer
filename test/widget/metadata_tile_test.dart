import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/widget/metadata_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => L10n.load(const Locale('en')));

  testWidgets('metadata tile toggles metadata use and inserts a selected tag',
      (tester) async {
    final controller = TextEditingController(text: 'prefix')
      ..selection = const TextSelection.collapsed(offset: 6);
    final usesMetadata = ValueNotifier(false);
    addTearDown(() {
      controller.dispose();
      usesMetadata.dispose();
    });
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MetadataTile(
          textController: controller,
          withMetadata: usesMetadata,
        ),
      ),
    ));

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(usesMetadata.value, isTrue);

    await tester.tap(find.byIcon(Icons.info_outline_rounded));
    await tester.pumpAndSettle();
    final fileSizeTile = find.ancestor(
      of: find.text('File:Size'),
      matching: find.byType(ListTile),
    );
    await tester.ensureVisible(fileSizeTile);
    await tester.tap(
      find.descendant(of: fileSizeTile, matching: find.byIcon(Icons.add)),
    );
    await tester.pumpAndSettle();

    expect(controller.text, 'prefix{File:Size}');
    expect(usesMetadata.value, isTrue);
  });
}

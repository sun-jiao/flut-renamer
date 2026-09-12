import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/dialogs/metadata_dialog.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/tools/ex_text_editing_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => L10n.load(const Locale('en')));

  testWidgets('metadata dialog validates and inserts a random-string tag',
      (tester) async {
    String? inserted;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                showMetadataDialog(context, (tag) => inserted = tag),
            child: const Text('open'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    final field = find.byType(TextFormField);
    await tester.enterText(field, '0');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pump();
    expect(find.text(L10n.current.randomStringLengthError), findsOneWidget);

    await tester.enterText(field, '12');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await tester.pumpAndSettle();
    expect(inserted, '{RandomString:12}');
  });

  testWidgets('text controller inserts a tag at the cursor', (tester) async {
    final controller = TextEditingController(text: 'before-after')
      ..selection = const TextSelection.collapsed(offset: 7);
    addTearDown(controller.dispose);
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (value) {
            context = value;
            return TextField(controller: controller);
          },
        ),
      ),
    ));

    controller.insertTag('{File:Size}', context);
    expect(controller.text, 'before-{File:Size}after');
    expect(controller.selection.baseOffset, 18);
  });
}

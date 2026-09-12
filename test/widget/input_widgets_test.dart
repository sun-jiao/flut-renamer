import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/tools/file_metadata.dart';
import 'package:flut_renamer/widget/date_format_dropdown.dart';
import 'package:flut_renamer/widget/text_field_with_direction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => L10n.load(const Locale('en')));

  testWidgets(
      'date format dropdown presents unique formats and notifies changes',
      (tester) async {
    var selected = FileMetadata.defaultDateFormat;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => DateFormatDropdown(
            value: selected,
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    ));

    expect(FileMetadata.dateFormats.toSet(),
        hasLength(FileMetadata.dateFormats.length));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('yyyyMMdd').last);
    await tester.pumpAndSettle();
    expect(selected, 'yyyyMMdd');
  });

  testWidgets(
      'direction field accepts digits and switches to end-relative mode',
      (tester) async {
    final controller = TextEditingController();
    final toEnd = ValueNotifier(false);
    addTearDown(() {
      controller.dispose();
      toEnd.dispose();
    });
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DirectionTextField(
          con: controller,
          toEnd: toEnd,
          labelText: 'Position',
        ),
      ),
    ));

    await tester.enterText(find.byType(TextFormField), '12abc');
    expect(controller.text, '12');
    await tester.tap(find.widgetWithText(TextButton, L10n.current.toLast));
    await tester.pump();
    expect(toEnd.value, isTrue);
  });
}

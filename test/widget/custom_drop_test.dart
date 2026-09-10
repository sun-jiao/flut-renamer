import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/widget/custom_drop.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await L10n.load(const Locale('en'));
  });

  testWidgets('shows choices and notifies when the selected item changes',
      (tester) async {
    var selected = 'Files';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => CustomDrop<String>(
              value: selected,
              items: const ['Files', 'Directories', 'Files & Dirs'],
              onChanged: (value) {
                setState(() {
                  selected = value!;
                });
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Files'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    expect(find.text('Directories'), findsOneWidget);
    expect(find.text('Files & Dirs'), findsOneWidget);

    await tester.tap(find.text('Directories').last);
    await tester.pumpAndSettle();

    expect(selected, 'Directories');
    expect(find.text('Directories'), findsOneWidget);
  });
}

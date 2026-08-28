import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/file_metadata.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await L10n.load(const Locale('en'));
  });

  testWidgets('filters, selects, and clears files from the list',
      (tester) async {
    // Missing files avoid metadata and platform-plugin work while exercising
    // the list controls exactly as a deleted file entry would.
    FilesPage.addFiles([
      FileEntity(File('/tmp/flut_renamer_alpha_missing')),
      FileEntity(File('/tmp/flut_renamer_beta_missing')),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            FileListColors(
              primaryColor: Colors.white,
              secondaryColor: Colors.grey.shade100,
            ),
          ],
        ),
        home: Scaffold(
          body: FilesPage(
            getNewName: (name, FileMetadata _) => name,
            clearRules: () {},
            resetRules: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(L10n.current.fileNotExist), findsNWidgets(4));
    expect(find.byType(Checkbox), findsNWidgets(3));

    await tester.enterText(find.byType(TextField), 'beta');
    await tester.pump();
    expect(find.text(L10n.current.fileNotExist), findsNWidgets(2));
    expect(find.byType(Checkbox), findsNWidgets(2));

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox));
    expect(checkboxes.every((checkbox) => checkbox.value == true), isTrue);

    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pump();
    expect(find.text(L10n.current.dragToAdd), findsOneWidget);
  });
}

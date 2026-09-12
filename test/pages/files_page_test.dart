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
            dependsOnFileOrder: () => false,
            requiresMetadata: () => false,
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

  testWidgets('deduplicates files across and within selections',
      (tester) async {
    final first = FileEntity(File('/tmp/flut_renamer_first_missing'));
    final second = FileEntity(File('/tmp/flut_renamer_second_missing'));
    FilesPage.addFiles([first]);
    FilesPage.addFiles([second, first, second]);

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
            dependsOnFileOrder: () => false,
            requiresMetadata: () => false,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(L10n.current.fileNotExist), findsNWidgets(4));
    expect(find.byType(Checkbox), findsNWidgets(3));

    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pump();
  });

  testWidgets('keeps generated names stable across unrelated rebuilds',
      (tester) async {
    final key = GlobalKey<FilesPageState>();
    var generationCount = 0;
    final entity = FileEntity(File('assets/icon.png'));
    FilesPage.addFiles([entity]);
    await tester.runAsync(entity.initMetadata);

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
            key: key,
            getNewName: (name, FileMetadata _) =>
                'generated-${++generationCount}',
            clearRules: () {},
            resetRules: () {},
            dependsOnFileOrder: () => false,
            requiresMetadata: () => false,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(entity.existsSync(), isTrue);
    expect(entity.fileOrDir(), 'File');
    expect(find.text('icon.png'), findsOneWidget);

    expect(generationCount, 1);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();

    expect(generationCount, 1);

    key.currentState!.update();
    await tester.pump();

    expect(generationCount, 2);

    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pump();
  });

  testWidgets('only recalculates generated names after sorting when required',
      (tester) async {
    Future<int> sortAndCount({required bool dependsOnFileOrder}) async {
      var generationCount = 0;
      final files = [
        FileEntity(File('assets/icon.png')),
      ];
      FilesPage.addFiles(files);
      await tester.runAsync(() async {
        for (final file in files) {
          await file.initMetadata();
        }
      });

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
              getNewName: (name, FileMetadata _) =>
                  'generated-${++generationCount}',
              clearRules: () {},
              resetRules: () {},
              dependsOnFileOrder: () => dependsOnFileOrder,
              requiresMetadata: () => false,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(generationCount, 1);

      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byTooltip(L10n.current.removeAll));
      await tester.pump();
      return generationCount;
    }

    expect(await sortAndCount(dependsOnFileOrder: false), 1);
    expect(await sortAndCount(dependsOnFileOrder: true), 2);
  });

  testWidgets('renames only selected files and retains list entries on request',
      (tester) async {
    final directory = await Directory.systemTemp.createTemp('files_rename_');
    addTearDown(() => directory.delete(recursive: true));
    final selected = File('${directory.path}/selected.txt');
    final untouched = File('${directory.path}/untouched.txt');
    await selected.writeAsString('selected');
    await untouched.writeAsString('untouched');
    final selectedEntity = FileEntity(selected)..selected = true;
    final untouchedEntity = FileEntity(untouched);
    final key = GlobalKey<FilesPageState>();
    FilesPage.addFiles([selectedEntity, untouchedEntity]);

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
            key: key,
            getNewName: (name, FileMetadata _) => 'renamed-$name',
            clearRules: () {},
            resetRules: () {},
            dependsOnFileOrder: () => false,
            requiresMetadata: () => false,
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.runAsync(
      () => key.currentState!.renameFiles(remove: false, onlySelected: true),
    );
    await tester.pump();

    expect(await File('${directory.path}/renamed-selected.txt').readAsString(),
        'selected');
    expect(await untouched.readAsString(), 'untouched');
    expect(find.text('renamed-selected.txt'), findsOneWidget);
  });
}

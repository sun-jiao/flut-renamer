import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/file_metadata.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  setUpAll(() => L10n.load(const Locale('en')));
  setUp(() async {
    root = Directory.systemTemp.createTempSync('renamer_descendants_');
    SharedPreferences.setMockInitialValues({'file_or_dir': 'Files & Dirs'});
    await Shared.init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) async => root.path);
  });
  tearDown(() async {
    await Logger().flush();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    root.deleteSync(recursive: true);
  });

  for (final remove in [false, true]) {
    for (final nested in [false, true]) {
      testWidgets(
          'unselected child follows parents, remove=$remove nested=$nested',
          (tester) async {
        final parent = Directory('${root.path}/folder')..createSync();
        final inner = Directory('${parent.path}/inner')..createSync();
        final child = File('${inner.path}/child.txt')
          ..writeAsStringSync('child');
        final sibling = Directory('${root.path}/folder-other')..createSync();
        final outside = File('${sibling.path}/outside.txt')
          ..writeAsStringSync('outside');
        final childEntry = FileEntity(child);
        await tester.runAsync(() async {
          await childEntry.initMetadata();
          await childEntry.preloadSortMetadata();
        });
        final files = [
          FileEntity(parent, selected: true),
          if (nested) FileEntity(inner, selected: true),
          childEntry,
          FileEntity(outside),
        ];
        await _withPage(tester, files, (name, metadata) async {
          await metadata.init();
          return 'new-$name';
        }, (state) async {
          await tester.runAsync(
            () => state.renameFiles(remove: remove, onlySelected: true),
          );
          await _settle(tester);
          final rows = _rows(tester);
          final relocated =
              rows.singleWhere((file) => file.name == 'child.txt');
          final newPath =
              '${root.path}/new-folder/${nested ? 'new-inner' : 'inner'}/child.txt';
          expect(relocated.path, newPath);
          expect(relocated.selected, isFalse);
          expect(relocated.error, isNull);
          expect(relocated.metadata!.file.path, newPath);
          expect(relocated.sortMetadata, isNull);
          expect(
            rows.singleWhere((file) => file.name == 'outside.txt').path,
            outside.path,
          );
          expect(rows.length, remove ? 2 : files.length);
          expect(File(newPath).readAsStringSync(), 'child');

          // The retained row must remain usable for a subsequent rename.
          for (final row in rows) {
            row.selected = identical(row, relocated);
          }
          await tester.runAsync(
            () => state.renameFiles(remove: false, onlySelected: true),
          );
          await _settle(tester);
          expect(
            File('${File(newPath).parent.path}/new-child.txt')
                .readAsStringSync(),
            'child',
          );
          expect(
            _rows(tester)
                .singleWhere((file) => file.name == 'new-child.txt')
                .error,
            isNull,
          );
        });
      });
    }
  }

  testWidgets('unselected children follow their own directory during a swap',
      (tester) async {
    final a = Directory('${root.path}/a')..createSync();
    final b = Directory('${root.path}/b')..createSync();
    final first = File('${a.path}/first.txt')..writeAsStringSync('first');
    final second = File('${b.path}/second.txt')..writeAsStringSync('second');
    await _withPage(
        tester,
        [
          FileEntity(a, selected: true),
          FileEntity(b, selected: true),
          FileEntity(first),
          FileEntity(second),
        ],
        (name, _) async => {'a': 'b', 'b': 'a'}[name] ?? name, (state) async {
      await tester.runAsync(() => state.renameFiles(onlySelected: true));
      await _settle(tester);
      final rows = _rows(tester);
      expect(
        rows.map((file) => file.path),
        ['${b.path}/first.txt', '${a.path}/second.txt'],
      );
      expect(
        rows.map((file) => File(file.path).readAsStringSync()),
        ['first', 'second'],
      );
      expect(rows.map((file) => file.error), everyElement(isNull));
    });
  });
}

List<FileEntity> _rows(WidgetTester tester) => tester
    .widgetList<Table>(find.byType(Table))
    .map((table) => table.key)
    .whereType<ValueKey<FileEntity>>()
    .map((key) => key.value)
    .toList();

Future<void> _withPage(
  WidgetTester tester,
  List<FileEntity> files,
  Future<String> Function(String, FileMetadata) generate,
  Future<void> Function(FilesPageState) body,
) async {
  final key = GlobalKey<FilesPageState>();
  FilesPage.addFiles(files);
  try {
    await tester.runAsync(
      () => tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              FileListColors(
                primaryColor: Colors.white,
                secondaryColor: Colors.grey,
              ),
            ],
          ),
          home: Scaffold(
            body: FilesPage(
              key: key,
              getNewName: generate,
              clearRules: () {},
              resetRules: () {},
              requiresMetadata: () => true,
              dependsOnFileOrder: () => false,
            ),
          ),
        ),
      ),
    );
    await _settle(tester);
    await body(key.currentState!);
    expect(tester.takeException(), isNull);
  } finally {
    await tester.pump();
    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pump();
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(() async {
    final elapsed = Stopwatch()..start();
    do {
      await Future<void>.delayed(const Duration(milliseconds: 2));
      await tester.pump();
    } while (find.byType(LinearProgressIndicator).evaluate().isNotEmpty &&
        elapsed.elapsed < const Duration(seconds: 5));
  });
  expect(find.byType(LinearProgressIndicator), findsNothing);
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() => L10n.load(const Locale('en')));
  setUp(() async {
    directory = Directory.systemTemp.createTempSync('renamer_link_list_');
    SharedPreferences.setMockInitialValues({'file_or_dir': 'Files'});
    await Shared.init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, (_) async => directory.path);
  });
  tearDown(() async {
    await Logger().flush();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
    directory.deleteSync(recursive: true);
  });

  testWidgets(
    'broken links do not prevent listing or renaming a selected file',
    (tester) async {
      final normal = File('${directory.path}/normal.txt')
        ..writeAsStringSync('normal');
      final dangling = Link('${directory.path}/dangling')
        ..createSync('missing');
      final cycle = Link('${directory.path}/cycle')..createSync('cycle');
      final normalEntry = normal.path.toFileEntity()..selected = true;
      final brokenEntries = [
        dangling.path.toFileEntity(),
        cycle.path.toFileEntity(),
      ];
      final key = GlobalKey<FilesPageState>();
      FilesPage.addFiles([normalEntry, ...brokenEntries]);

      try {
        await tester.runAsync(() async {
          await tester.pumpWidget(_page(key));
          for (final entry in [normalEntry, ...brokenEntries]) {
            await key.currentState!.getNewName(entry);
          }
        });
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.byType(Checkbox), findsNWidgets(4));
        expect(find.text('dangling'), findsWidgets);
        expect(find.text('cycle'), findsWidgets);
        expect(normalEntry.error, isNull);
        expect(brokenEntries.every((entry) => entry.error != null), isTrue);

        await tester.enterText(find.byType(TextField), 'dangling');
        await tester.pump();
        expect(find.byType(Checkbox), findsNWidgets(2));
        await tester.enterText(find.byType(TextField), '');
        await tester.runAsync(
          () => key.currentState!.renameFiles(
            remove: false,
            onlySelected: true,
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(
          File('${directory.path}/renamed-normal.txt').readAsStringSync(),
          'normal',
        );
        expect(normal.existsSync(), isFalse);
        expect(dangling.targetSync(), 'missing');
        expect(cycle.targetSync(), 'cycle');
        expect(File('${directory.path}/missing').existsSync(), isFalse);
      } finally {
        await tester.tap(find.byTooltip(L10n.current.removeAll));
        await tester.pump();
      }
      expect(find.byType(Checkbox), findsOneWidget);
    },
    skip: Platform.isWindows,
  );

  testWidgets(
    'relative directory links retain the directory filter after rename',
    (tester) async {
      final target = Directory('${directory.path}/target')..createSync();
      final contents = File('${target.path}/contents.txt')
        ..writeAsStringSync('contents');
      final link = Link('${directory.path}/shortcut')..createSync('target');
      Shared.fileOrDir = 'Directories';
      final key = GlobalKey<FilesPageState>();
      FilesPage.addFiles([link.path.toFileEntity()]);
      try {
        await tester.runAsync(() async {
          await tester.pumpWidget(_page(key));
          await key.currentState!.renameFiles(remove: false);
        });
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.byType(Checkbox), findsNWidgets(2));
        expect(find.text('renamed-shortcut'), findsWidgets);
        expect(link.existsSync(), isFalse);
        expect(
          Link('${directory.path}/renamed-shortcut').targetSync(),
          'target',
        );
        expect(contents.readAsStringSync(), 'contents');
        expect(
          Directory('${directory.path}/renamed-target').existsSync(),
          isFalse,
        );
      } finally {
        await tester.tap(find.byTooltip(L10n.current.removeAll));
        await tester.pump();
      }
    },
    skip: Platform.isWindows,
  );
}

Widget _page(GlobalKey<FilesPageState> key) => MaterialApp(
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
          getNewName: (name, _) => 'renamed-$name',
          clearRules: () {},
          resetRules: () {},
          dependsOnFileOrder: () => false,
          requiresMetadata: () => false,
        ),
      ),
    );

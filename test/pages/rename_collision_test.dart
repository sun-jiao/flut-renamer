import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/file_metadata.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  setUpAll(() => L10n.load(const Locale('en')));
  setUp(() async {
    directory = Directory.systemTemp.createTempSync('renamer_collision_');
    SharedPreferences.setMockInitialValues(
      {'file_or_dir': 'Files', 'only_selected': false},
    );
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

  FileEntity addFile(String name, [String? contents]) => FileEntity(
        File('${directory.path}/$name')..writeAsStringSync(contents ?? name),
      );
  String read(String name) =>
      File('${directory.path}/$name').readAsStringSync();
  void expectNoTemporaryFiles() => expect(
        directory
            .listSync()
            .where((entry) => entry.path.contains('.renamer-tmp-')),
        isEmpty,
      );

  Future<void> chooseScope(WidgetTester tester, String label) async {
    await tester.tap(find.byKey(const ValueKey('renameScope')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await _settle(tester);
  }

  testWidgets(
      'default scope respects text and type filters and keeps numbering',
      (tester) async {
    final hidden = addFile('hidden.txt');
    final visible = addFile('visible.txt');
    final folder =
        FileEntity(Directory('${directory.path}/visible-folder')..createSync());
    var number = 0;
    await _withPage(
      tester,
      [hidden, visible, folder],
      (name, _) => '${++number}.txt',
      (state) async {
        // Filtering does not renumber the preview; the visible item remains #2.
        number = 0;
        await tester.enterText(find.byType(TextField), 'visible');
        await _settle(tester);
        expect(
          find.text(L10n.current.renameTargetSummary(1, 0)),
          findsOneWidget,
        );
        expect(visible.newName, '2.txt');
        await tester.runAsync(() => state.renameFiles(remove: false));
        expect(read('2.txt'), 'visible.txt');
        expect(hidden.existsSync(), isTrue);
        expect(folder.existsSync(), isTrue);
        expect(File('${directory.path}/1.txt').existsSync(), isFalse);
      },
      ordered: true,
    );
  });

  testWidgets(
      'all scope explicitly includes filtered-out files and directories',
      (tester) async {
    final files = [addFile('visible.txt'), addFile('hidden.txt')];
    final folder =
        FileEntity(Directory('${directory.path}/folder')..createSync());
    await _withPage(tester, [...files, folder], (name, _) => 'new-$name',
        (state) async {
      await tester.enterText(find.byType(TextField), 'visible');
      await _settle(tester);
      await chooseScope(tester, L10n.current.scopeAll);
      expect(find.text(L10n.current.renameTargetSummary(3, 2)), findsOneWidget);
      await tester.runAsync(() => state.renameFiles(remove: false));
      expect(read('new-visible.txt'), 'visible.txt');
      expect(read('new-hidden.txt'), 'hidden.txt');
      expect(Directory('${directory.path}/new-folder').existsSync(), isTrue);
    });
  });

  testWidgets(
      'header selects visible rows and selected scope reports hidden ones',
      (tester) async {
    final visible = addFile('visible.txt');
    final hidden = addFile('hidden.txt');
    await _withPage(tester, [visible, hidden], (name, _) => 'new-$name',
        (state) async {
      await tester.enterText(find.byType(TextField), 'visible');
      await _settle(tester);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();
      expect(visible.selected, isTrue);
      expect(hidden.selected, isFalse);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();
      expect(visible.selected, isFalse);
      expect(hidden.selected, isFalse);
      await tester.tap(find.byType(Checkbox).first);
      await tester.enterText(find.byType(TextField), 'hidden');
      await _settle(tester);
      await chooseScope(tester, L10n.current.scopeSelected);
      expect(find.text(L10n.current.renameTargetSummary(1, 1)), findsOneWidget);
      await tester.runAsync(() => state.renameFiles(remove: false));
      expect(read('new-visible.txt'), 'visible.txt');
      expect(hidden.existsSync(), isTrue);
    });
  });

  testWidgets(
      'filtered scope rejects a destination occupied by a hidden source',
      (tester) async {
    final files = [addFile('a'), addFile('b')];
    await _withPage(tester, files, (name, _) => name == 'a' ? 'b' : 'c',
        (state) async {
      await tester.enterText(find.byType(TextField), 'a');
      await _settle(tester);
      expect(files.first.error, L10n.current.fileAlreadyExists);
      await tester.runAsync(() => state.renameFiles(remove: false));
      expect(read('a'), 'a');
      expect(read('b'), 'b');
      await chooseScope(tester, L10n.current.scopeAll);
      expect(files.map((file) => file.error), everyElement(isNull));
      await tester.runAsync(() => state.renameFiles(remove: false));
      expect(read('b'), 'a');
      expect(read('c'), 'b');
    });
  });

  testWidgets('empty filtered scope leaves every file untouched',
      (tester) async {
    final files = [addFile('a')];
    await _withPage(tester, files, (name, _) => 'new-$name', (state) async {
      await tester.enterText(find.byType(TextField), 'no-match');
      await _settle(tester);
      expect(find.text(L10n.current.renameTargetSummary(0, 0)), findsOneWidget);
      await tester.runAsync(() => state.renameFiles());
      expect(read('a'), 'a');
      expect(File('${directory.path}/new-a').existsSync(), isFalse);
    });
  });

  testWidgets('rearrange preview and commit allow a two-file swap',
      (tester) async {
    final files = [addFile('a-b'), addFile('b-a')];
    final rule = RuleRearrange('-', [2, 1], false);
    await _withPage(tester, files, (name, _) => rule.newName(name),
        (state) async {
      expect(files.map((file) => file.newName), ['b-a', 'a-b']);
      expect(files.map((file) => file.error), everyElement(isNull));
      expect(find.byTooltip(L10n.current.fileAlreadyExists), findsNothing);
      await _rename(tester, state);
      expect(read('a-b'), 'b-a');
      expect(read('b-a'), 'a-b');
      expectNoTemporaryFiles();
    });
  });

  for (final ordered in [false, true]) {
    testWidgets('allows a three-file cycle with ordered=$ordered',
        (tester) async {
      final files = [addFile('a'), addFile('b'), addFile('c')];
      final names = {'a': 'b', 'b': 'c', 'c': 'a'};
      await _withPage(
        tester,
        files,
        (name, _) => names[name]!,
        (state) async {
          expect(files.map((file) => file.error), everyElement(isNull));
          await _rename(tester, state);
          expect(read('a'), 'c');
          expect(read('b'), 'a');
          expect(read('c'), 'b');
          expectNoTemporaryFiles();
        },
        ordered: ordered,
      );
    });
  }

  testWidgets('allows a chain whose final destination is free', (tester) async {
    final files = [addFile('a'), addFile('b')];
    await _withPage(tester, files, (name, _) => name == 'a' ? 'b' : 'c',
        (state) async {
      expect(files.map((file) => file.error), everyElement(isNull));
      await _rename(tester, state);
      expect(File('${directory.path}/a').existsSync(), isFalse);
      expect(read('b'), 'a');
      expect(read('c'), 'b');
      expectNoTemporaryFiles();
    });
  });

  for (final stationary in [false, true]) {
    testWidgets(
        'blocks ${stationary ? 'a stationary source' : 'duplicate new targets'}',
        (tester) async {
      final files = [addFile('a'), addFile('b')];
      await _withPage(tester, files, (name, _) => stationary ? 'b' : 'new',
          (state) async {
        expect(
          files.map((file) => file.error),
          everyElement(L10n.current.fileAlreadyExists),
        );
        await _rename(tester, state);
        expect(read('a'), 'a');
        expect(read('b'), 'b');
        expect(File('${directory.path}/new').existsSync(), isFalse);
        expectNoTemporaryFiles();
      });
    });
  }

  for (final kind in ['file', 'directory', 'dangling link']) {
    testWidgets(
      'blocks an external $kind in preview and commit',
      (tester) async {
        final files = [addFile('a')];
        final destination = '${directory.path}/occupied';
        if (kind == 'file') {
          File(destination).writeAsStringSync('external');
        } else if (kind == 'directory') {
          Directory(destination).createSync();
        } else {
          Link(destination).createSync('missing');
        }
        await _withPage(tester, files, (name, _) => 'occupied', (state) async {
          expect(files.single.error, L10n.current.fileAlreadyExists);
          await _rename(tester, state);
          expect(read('a'), 'a');
          if (kind == 'file') expect(read('occupied'), 'external');
          if (kind == 'directory') {
            expect(Directory(destination).existsSync(), isTrue);
          }
          if (kind == 'dangling link') {
            expect(Link(destination).targetSync(), 'missing');
          }
        });
      },
      skip: kind == 'dangling link' && Platform.isWindows,
    );
  }

  testWidgets('propagates a blocked move through its dependent sources',
      (tester) async {
    final files = [addFile('a'), addFile('b'), addFile('c')];
    addFile('occupied', 'external');
    final names = {'a': 'b', 'b': 'c', 'c': 'occupied'};
    await _withPage(tester, files, (name, _) => names[name]!, (state) async {
      expect(
        files.map((file) => file.error),
        everyElement(L10n.current.fileAlreadyExists),
      );
      await _rename(tester, state);
      for (final name in ['a', 'b', 'c']) {
        expect(read(name), name);
      }
      expect(read('occupied'), 'external');
      expectNoTemporaryFiles();
    });
  });

  testWidgets('a failed name generation cannot free its source path',
      (tester) async {
    final files = [addFile('a'), addFile('b')];
    await _withPage(tester, files, (name, _) {
      if (name == 'b') throw const FormatException('Invalid rule');
      return 'b';
    }, (state) async {
      expect(files.first.error, L10n.current.fileAlreadyExists);
      expect(files.last.error, contains('Invalid rule'));
      await _rename(tester, state);
      expect(read('a'), 'a');
      expect(read('b'), 'b');
    });
  });

  testWidgets(
      'rechecks selected sources and can retry without regenerating names',
      (tester) async {
    final files = [addFile('a')..selected = true, addFile('b')];
    var generated = 0;
    await _withPage(tester, files, (name, _) {
      generated++;
      return name == 'a' ? 'b' : 'a';
    }, (state) async {
      expect(files.map((file) => file.error), everyElement(isNull));
      await _rename(tester, state, onlySelected: true);
      expect(files.first.error, L10n.current.fileAlreadyExists);
      expect(read('a'), 'a');
      expect(read('b'), 'b');

      files.last.selected = true;
      await _rename(tester, state, onlySelected: true);
      expect(generated, 2);
      expect(read('a'), 'b');
      expect(read('b'), 'a');
      expectNoTemporaryFiles();
    });
  });

  testWidgets('an unselected duplicate target does not block a valid subset',
      (tester) async {
    final files = [addFile('a')..selected = true, addFile('b')];
    await _withPage(tester, files, (name, _) => 'new', (state) async {
      expect(files.first.error, L10n.current.fileAlreadyExists);
      await _rename(tester, state, onlySelected: true);
      expect(read('new'), 'a');
      expect(read('b'), 'b');
      expect(File('${directory.path}/a').existsSync(), isFalse);
    });
  });

  testWidgets('rechecks disk contents after a successful preview',
      (tester) async {
    final files = [addFile('a')];
    await _withPage(tester, files, (name, _) => 'new', (state) async {
      expect(files.single.error, isNull);
      addFile('new', 'external');
      await _rename(tester, state);
      expect(files.single.error, L10n.current.fileAlreadyExists);
      expect(read('a'), 'a');
      expect(read('new'), 'external');
    });
  });

  testWidgets('waits for asynchronous swap names before checking collisions',
      (tester) async {
    final files = [addFile('a'), addFile('b')];
    final pending = Completer<String>();
    await _withPage(
      tester,
      files,
      (name, _) async => name == 'a' ? 'b' : await pending.future,
      (state) async {
        try {
          await tester.pump();
          expect(files.first.error, isNull);
          expect(find.byType(LinearProgressIndicator), findsWidgets);
          pending.complete('a');
          await _settle(tester);
          expect(files.map((file) => file.error), everyElement(isNull));
          await _rename(tester, state);
          expect(read('a'), 'b');
          expect(read('b'), 'a');
        } finally {
          if (!pending.isCompleted) pending.complete('a');
        }
      },
      settle: false,
      metadata: true,
    );
  });

  testWidgets('can retry when an external collision disappears',
      (tester) async {
    final files = [addFile('a')];
    final occupied = addFile('new', 'external');
    await _withPage(tester, files, (name, _) => 'new', (state) async {
      expect(files.single.error, L10n.current.fileAlreadyExists);
      occupied.entity.deleteSync();
      await _rename(tester, state);
      expect(read('new'), 'a');
      expect(File('${directory.path}/a').existsSync(), isFalse);
    });
  });

  testWidgets('discarded asynchronous names cannot overwrite a newer preview',
      (tester) async {
    final files = [addFile('a'), addFile('b')];
    final oldName = Completer<String>();
    var changedRules = false;
    await _withPage(
      tester,
      files,
      (name, _) async {
        if (changedRules) return 'new-$name';
        return name == 'a' ? await oldName.future : 'b';
      },
      (state) async {
        try {
          changedRules = true;
          state.update();
          await _settle(tester);
          oldName.complete('b');
          await _settle(tester);
          expect(files.map((file) => file.newName), ['new-a', 'new-b']);
          expect(files.map((file) => file.error), everyElement(isNull));
          await _rename(tester, state);
          expect(read('new-a'), 'a');
          expect(read('new-b'), 'b');
        } finally {
          if (!oldName.isCompleted) oldName.complete('b');
        }
      },
      settle: false,
    );
  });
}

Future<void> _withPage(
  WidgetTester tester,
  List<FileEntity> files,
  FutureOr<String> Function(String, FileMetadata) generate,
  Future<void> Function(FilesPageState) body, {
  bool ordered = false,
  bool metadata = false,
  bool settle = true,
}) async {
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
              dependsOnFileOrder: () => ordered,
              requiresMetadata: () => metadata,
            ),
          ),
        ),
      ),
    );
    if (settle) await _settle(tester);
    await body(key.currentState!);
    expect(tester.takeException(), isNull);
  } finally {
    await tester.pump();
    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pump();
  }
}

Future<void> _settle(WidgetTester tester) async {
  // Filesystem checks need real event-loop turns, not just fake-clock frames.
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

Future<void> _rename(
  WidgetTester tester,
  FilesPageState state, {
  bool onlySelected = false,
}) async {
  await tester.runAsync(() async {
    await state.renameFiles(remove: false, onlySelected: onlySelected);
    await Logger().flush();
  });
}

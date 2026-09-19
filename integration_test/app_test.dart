import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/transliterate.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/main.dart' as app;
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/pages/rules_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:flut_renamer/tools/rename.dart';
import 'package:flut_renamer/tools/rename_transaction.dart';
import 'package:flut_renamer/tools/rule_persistence.dart';
import 'support/environment.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await requireTestEnvironment();
    await L10n.load(const Locale('en'));
    await Shared.init();
  });

  final cases = <(String, String, String, Rule Function())>[
    (
      'insert',
      'photo.txt',
      'prefix-photo.txt',
      () => RuleInsert('prefix-', 0, false, false, true)
    ),
    (
      'replace limit',
      'old-old.txt',
      'new-old.txt',
      () => RuleReplace('old', 'new', 1, false, true, false, true)
    ),
    (
      'regex captures',
      'photo-42.txt',
      '42-photo.txt',
      () => RuleReplace(r'(photo)-(\d+)', r'\2-\1', 0, false, true, true, true)
    ),
    (
      'remove from end',
      'draft-draft.txt',
      'draft-.txt',
      () => RuleRemove('draft', -1, true, false, true)
    ),
    (
      'increment padding',
      'photo.txt',
      'image-007.txt',
      () => RuleIncrement('image', 7, 2, false, true, minimumDigits: 3)
    ),
    (
      'rearrange',
      'first-last.txt',
      'last-first.txt',
      () => RuleRearrange('-', [2, 1], true)
    ),
    (
      'truncate',
      'abcdef.txt',
      'bcd.txt',
      () => RuleTruncate(1, 4, false, false, true, true)
    ),
    (
      'uppercase',
      'photo.txt',
      'PHOTO.txt',
      () => RuleTransliterate(Transliterate.upper)
    ),
    (
      'unicode spaces',
      '照片 你好.txt',
      '归档-照片 你好.txt',
      () => RuleInsert('归档-', 0, false, false, true)
    ),
    (
      'hidden file',
      '.env',
      'backup-.env',
      () => RuleInsert('backup-', 0, false, false, true)
    ),
    (
      'multiple extensions',
      'archive.tar.gz',
      'archive.tar-backup.gz',
      () => RuleInsert('-backup', 0, true, false, true)
    ),
    (
      'unsafe characters',
      'photo.txt',
      'a∕b∶photo.txt',
      () => RuleInsert('a/b:', 0, false, false, true)
    ),
  ];
  for (final (label, sourceName, targetName, makeRule) in cases) {
    scenario('real rename: $label', (f) async {
      final source = await f.addFile(sourceName, 'payload-$label');
      await f.addRule(makeRule());
      await f.until(() => source.newName == targetName);
      await f.tapRename();
      // existsSync is already true before a case-only rename on NTFS/APFS.
      await f.until(
        () => f.root
            .listSync()
            .any((entity) => p.basename(entity.path) == targetName),
      );
      expect(f.file(targetName).readAsStringSync(), 'payload-$label');
      // APFS/NTFS can resolve the old spelling after a case-only rename.
      expect(
        f.root.listSync().map((e) => p.basename(e.path)),
        isNot(contains(sourceName)),
      );
      expect(find.text(targetName), findsWidgets);
    });
  }

  scenario('empty batch and no-op preserve the filesystem', (f) async {
    await f.files.renameFiles(remove: false, onlySelected: false);
    expect(f.root.listSync(), isEmpty);
    await f.addFile('unchanged.txt', 'original');
    await f.files.renameFiles(remove: false, onlySelected: false);
    expect(f.file('unchanged.txt').readAsStringSync(), 'original');
    expect(f.root.listSync(), hasLength(1));
  });

  scenario('only-selected: none, then one of two files', (f) async {
    await f.addFile('one.txt', 'one');
    await f.addFile('two.txt', 'two');
    await f.addRule(RuleInsert('new-', 0, false, false, true));
    Shared.onlySelected = true;
    await f.files.renameFiles(remove: false, onlySelected: true);
    expect(f.root.listSync(), hasLength(2));
    expect(f.file('one.txt').existsSync(), isTrue);
    await f.tester.tap(f.inFiles(find.byType(Checkbox)).at(1));
    await f.tapRename();
    await f.until(() => f.file('new-one.txt').existsSync());
    expect(f.file('new-one.txt').readAsStringSync(), 'one');
    expect(f.file('two.txt').readAsStringSync(), 'two');
    expect(f.file('new-two.txt').existsSync(), isFalse);
  });

  for (final clearRules in [false, true]) {
    scenario('remove renamed rows, clear rules=$clearRules', (f) async {
      await f.addFile('source.txt');
      await f.addRule(RuleInsert('new-', 0, false, false, true));
      Shared.removeRenamed = true;
      Shared.removeRules = clearRules;
      await f.tapRename();
      await f
          .until(() => f.inFiles(find.byType(Checkbox)).evaluate().length == 1);
      expect(f.file('new-source.txt').existsSync(), isTrue);
      expect(f.rules.rules, hasLength(clearRules ? 0 : 1));
    });
  }

  for (final collision in [
    'existing file',
    'directory',
    'duplicate targets',
    'after preview',
  ]) {
    scenario('whole batch is protected: $collision', (f) async {
      final first = await f.addFile('one.txt', 'one');
      final second = await f.addFile('two.txt', 'two');
      if (collision == 'existing file') {
        f.file('new-one.txt').writeAsStringSync('external');
      }
      if (collision == 'directory') {
        Directory(f.file('new-one.txt').path).createSync();
      }
      await f.addRule(
        collision == 'duplicate targets'
            ? RuleIncrement('same', 1, 0, true, true)
            : RuleInsert('new-', 0, false, false, true),
      );
      await f
          .until(() => first.newName.isNotEmpty && second.newName.isNotEmpty);
      if (collision == 'after preview') {
        f.file('new-one.txt').writeAsStringSync('external');
      }
      await f.files.renameFiles(remove: true, onlySelected: false);
      expect(f.file('one.txt').readAsStringSync(), 'one');
      expect(f.file('two.txt').readAsStringSync(), 'two');
      expect(f.file('new-two.txt').existsSync(), isFalse);
      expect(f.file('same1.txt').existsSync(), isFalse);
      expect(f.rules.rules, hasLength(1));
      if (collision == 'existing file' || collision == 'after preview') {
        expect(f.file('new-one.txt').readAsStringSync(), 'external');
      }
      if (collision == 'directory') {
        expect(Directory(f.file('new-one.txt').path).existsSync(), isTrue);
      }
    });
  }

  scenario('deduplication, filter, select-all and list removal preserve files',
      (f) async {
    await f.addFile('Alpha.txt');
    await f.addFile('beta.txt');
    FilesPage.addFiles([FileEntity(f.file('Alpha.txt'))]);
    f.files.update();
    await f.tester.pumpAndSettle();
    expect(f.inFiles(find.byType(Checkbox)), findsNWidgets(3));
    await f.tester.enterText(f.inFiles(find.byType(TextField)), 'ALPHA');
    await f.tester.pumpAndSettle();
    expect(f.inFiles(find.byType(Checkbox)), findsNWidgets(2));
    await f.tester.tap(f.inFiles(find.byType(Checkbox)).first);
    await f.tester.enterText(f.inFiles(find.byType(TextField)), '');
    await f.tester.pumpAndSettle();
    expect(
      f.tester
          .widgetList<Checkbox>(f.inFiles(find.byType(Checkbox)))
          .every((c) => c.value == true),
      isTrue,
    );
    await f.tester.tap(f.inFiles(find.byTooltip(L10n.current.removeAll)));
    await f.tester.pumpAndSettle();
    expect(f.inFiles(find.byType(Checkbox)), findsOneWidget);
    expect(f.root.listSync(), hasLength(2));
  });

  scenario('sort invalidates sequential previews before commit', (f) async {
    final z = await f.addFile('z.txt', 'z');
    final a = await f.addFile('a.txt', 'a');
    await f.addRule(RuleIncrement('item', 1, 1, true, true));
    await f.until(() => a.newName == 'item2.txt');
    await f.tester.tap(f.inFiles(find.byIcon(Icons.arrow_upward)));
    await f.until(() => a.newName == 'item1.txt' && z.newName == 'item2.txt');
    await f.tapRename();
    await f.until(() => f.file('item2.txt').existsSync());
    expect(f.file('item1.txt').readAsStringSync(), 'a');
    expect(f.file('item2.txt').readAsStringSync(), 'z');
  });

  scenario('random preview remains stable through selection and commit',
      (f) async {
    final source = await f.addFile('source.txt');
    await f.addRule(RuleInsert('{RandomString:8}-', 0, false, false, true));
    await f.until(
      () => RegExp(r'^[a-f0-9]{8}-source.txt$').hasMatch(source.newName),
    );
    final preview = source.newName;
    await f.tester.tap(f.inFiles(find.byType(Checkbox)).last);
    await f.tester.pumpAndSettle();
    expect(source.newName, preview);
    await f.tapRename();
    await f.until(() => f.file(preview).existsSync());
    expect(f.file(preview).readAsStringSync(), 'payload');
  });

  scenario('real file metadata is used in the preview and commit', (f) async {
    final source = await f.addFile('photo.txt');
    f.file('photo.txt').setLastModifiedSync(DateTime(2020, 6, 15, 12));
    await f.addRule(
      RuleInsert(
        '{File:ModifyDate}-',
        0,
        false,
        true,
        true,
        dateFormat: 'yyyyMMdd',
      ),
    );
    await f.until(() => source.newName == '20200615-photo.txt');
    await f.tapRename();
    await f.until(() => f.file('20200615-photo.txt').existsSync());
  });

  scenario('rules survive native YAML storage and app remount', (f) async {
    for (final entry in cases) {
      await f.addRule(entry.$4());
    }
    final expected = f.rules.rules.map((r) => r.toMap()).toList();
    final oldRules = f.rules;
    await f.tester.pumpWidget(const SizedBox());
    oldRules.rules.clear();
    await f.tester.pumpWidget(const app.RenamerApp(locale: Locale('en')));
    await f.until(() => f.rules.rules.length == expected.length);
    expect(f.rules.rules.map((r) => r.toMap()).toList(), expected);
    final export = f.file('export.yaml');
    await RulePersistence.saveRules(f.rules.rules, targetFile: export);
    expect(
      (await RulePersistence.loadRules(sourceFile: export))
          .map((r) => r.toMap())
          .toList(),
      expected,
    );
    export.writeAsStringSync('[invalid: yaml');
    expect(await RulePersistence.loadRules(sourceFile: export), isEmpty);
    expect(
      await RulePersistence.loadRules(sourceFile: f.file('missing.yaml')),
      isEmpty,
    );
  });

  scenario('native preferences persist toolbar changes', (f) async {
    await f.tester
        .tap(find.widgetWithText(FilterChip, L10n.current.onlySelected));
    await f.tester.pumpAndSettle();
    await Shared.pref.reload();
    expect(Shared.pref.getBool('only_selected'), isTrue);
    await Shared.init();
    expect(Shared.onlySelected, isTrue);
  });

  scenario('rule dialog adds, edits, cancels and deletes with live previews',
      (f) async {
    final source = await f.addFile('source.txt');
    await f.tester.tap(find.byTooltip(L10n.current.addRule));
    await f.tester.pumpAndSettle();
    await f.tester.tap(find.text(L10n.current.insert).last);
    await f.tester.pumpAndSettle();
    await f.tester.enterText(find.byType(TextFormField).first, 'first-');
    await f.tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await f.until(() => source.newName == 'first-source.txt');
    await f.saved();
    final ruleTile = find.descendant(
      of: find.byType(RulesPage),
      matching: find.byType(ListTile),
    );
    await f.tester.tap(ruleTile.first);
    await f.tester.pumpAndSettle();
    expect(
      f.tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      'first-',
    );
    await f.tester.enterText(find.byType(TextFormField).first, 'edited-');
    await f.tester.tap(find.widgetWithText(TextButton, L10n.current.add));
    await f.until(() => source.newName == 'edited-source.txt');
    await f.saved();
    await f.tester.tap(ruleTile.first);
    await f.tester.pumpAndSettle();
    await f.tester.enterText(find.byType(TextFormField).first, 'cancelled-');
    await f.tester.tap(find.widgetWithText(TextButton, L10n.current.cancel));
    await f.tester.pumpAndSettle();
    expect(source.newName, 'edited-source.txt');
    await f.tester.tap(
      find.descendant(
        of: ruleTile.first,
        matching: find.byIcon(Icons.delete),
      ),
    );
    await f
        .until(() => f.rules.rules.isEmpty && source.newName == 'source.txt');
    await f.saved();
    expect(f.file('source.txt').readAsStringSync(), 'payload');
  });

  scenario('dragging rules changes the pipeline and saved order', (f) async {
    final source = await f.addFile('source.txt');
    await f.addRule(RuleInsert('a-', 0, false, false, true));
    await f.addRule(RuleReplace('a-', 'b-', 0, false, true, false, true));
    await f.until(() => source.newName == 'b-source.txt');
    final handles = find.descendant(
      of: find.byType(RulesPage),
      matching: find.byIcon(Icons.drag_handle),
    );
    final start = f.tester.getCenter(handles.first);
    final destination = f.tester.getCenter(handles.last) + const Offset(0, 40);
    final gesture = await f.tester.startGesture(start);
    await f.tester.pump();
    for (var step = 1; step <= 8; step++) {
      await gesture.moveTo(Offset.lerp(start, destination, step / 8)!);
      await f.tester.pump(const Duration(milliseconds: 100));
    }
    await f.tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await f.until(
      () =>
          f.rules.rules.first is RuleReplace &&
          source.newName == 'a-source.txt',
    );
    await f.saved();
    expect((await RulePersistence.loadRules()).first, isA<RuleReplace>());
  });

  scenario('successful rename appears in native log and log dialog', (f) async {
    await Logger().clearLogs();
    await f.addFile('logged-source.txt');
    await f.addRule(RuleInsert('new-', 0, false, false, true));
    await f.tapRename();
    final log = File(await Logger().getLogPath());
    await f.until(
      () =>
          log.existsSync() &&
          log.readAsStringSync().contains('new-logged-source.txt'),
    );
    expect(
      await Logger().readLogs(),
      contains(f.file('logged-source.txt').path),
    );
    await f.tester.tap(find.byTooltip(L10n.current.viewLog));
    await f.tester.pumpAndSettle();
    expect(find.textContaining('RENAME:'), findsOneWidget);
    await f.tester.tap(find.widgetWithText(TextButton, L10n.current.ok));
    await f.tester.pumpAndSettle();
  });

  scenario('native transaction commits a three-file cycle without leftovers',
      (f) async {
    for (final name in ['a', 'b', 'c']) {
      f.file(name).writeAsStringSync(name);
    }
    final result = await commitRenameTransaction([
      FileEntity(f.file('a'), newName: 'b'),
      FileEntity(f.file('b'), newName: 'c'),
      FileEntity(f.file('c'), newName: 'a'),
    ]);
    expect(result.succeeded, isTrue);
    expect([
      for (final name in ['a', 'b', 'c']) f.file(name).readAsStringSync(),
    ], [
      'c',
      'a',
      'b',
    ]);
    expect(f.root.listSync(), hasLength(3));
  });

  scenario('native transaction relocates a selected parent and child',
      (f) async {
    final parent = Directory(p.join(f.root.path, 'folder'))..createSync();
    final child = File(p.join(parent.path, 'old.txt'))
      ..writeAsStringSync('child');
    final result = await commitRenameTransaction([
      FileEntity(parent, newName: 'new-folder'),
      FileEntity(child, newName: 'new.txt'),
    ]);
    expect(result.succeeded, isTrue);
    expect(f.file('new-folder/new.txt').readAsStringSync(), 'child');
    expect(parent.existsSync(), isFalse);
    expect(result.entities[1].path, f.file('new-folder/new.txt').path);
  });

  for (final rollbackFails in [false, true]) {
    scenario(
        'real moves with injected failure; rollback failure=$rollbackFails',
        (f) async {
      f.file('a').writeAsStringSync('a');
      f.file('b').writeAsStringSync('b');
      var calls = 0;
      final result = await commitRenameTransaction(
        [
          FileEntity(f.file('a'), newName: 'new-a'),
          FileEntity(f.file('b'), newName: 'new-b'),
        ],
        operation: (entity, context) async {
          calls++;
          if (calls == 2 || (rollbackFails && calls == 3)) {
            throw const FileSystemException('injected failure');
          }
          return rename(entity);
        },
      );
      expect(result.succeeded, isFalse);
      expect(calls, 3);
      expect(f.file(rollbackFails ? 'new-a' : 'a').readAsStringSync(), 'a');
      expect(
        result.entities[0].path,
        f.file(rollbackFails ? 'new-a' : 'a').path,
      );
      expect(f.file('b').readAsStringSync(), 'b');
      expect(f.file('new-b').existsSync(), isFalse);
      expect(f.root.listSync(), hasLength(2));
    });
  }

  scenario('source disappearing during commit rolls back earlier real moves',
      (f) async {
    f.file('a').writeAsStringSync('a');
    f.file('b').writeAsStringSync('b');
    var calls = 0;
    final result = await commitRenameTransaction(
      [
        FileEntity(f.file('a'), newName: 'new-a'),
        FileEntity(f.file('b'), newName: 'new-b'),
      ],
      operation: (entity, context) async {
        if (++calls == 2) f.file('b').deleteSync();
        return rename(entity);
      },
    );
    expect(result.succeeded, isFalse);
    expect(f.file('a').readAsStringSync(), 'a');
    expect(f.file('new-a').existsSync(), isFalse);
    expect(f.file('new-b').existsSync(), isFalse);
    expect(result.entities.first.path, f.file('a').path);
  });

  // Windows symlink creation requires privileges/Developer Mode; do not
  // silently turn an unavailable capability into a passing test.
  if (!Platform.isWindows) {
    scenario('native atomic rename refuses a dangling symlink destination',
        (f) async {
      f.file('source').writeAsStringSync('source');
      final link = Link(f.file('destination').path)
        ..createSync(f.file('absent').path);
      final result =
          await rename(FileEntity(f.file('source'), newName: 'destination'));
      expect(result, isNull);
      expect(f.file('source').readAsStringSync(), 'source');
      expect(link.targetSync(), f.file('absent').path);
      expect(f.file('absent').existsSync(), isFalse);
    });
  }
}

void scenario(String name, Future<void> Function(Fixture) body) {
  testWidgets(
    name,
    (tester) async {
      final fixture = Fixture(tester);
      try {
        await fixture.start();
        await body(fixture);
        expect(tester.takeException(), isNull);
      } finally {
        await fixture.close();
      }
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

class Fixture {
  Fixture(this.tester);
  final WidgetTester tester;
  late Directory root;
  FilesPageState get files => tester.state(find.byType(FilesPage));
  RulesPageState get rules => tester.state(find.byType(RulesPage));
  Finder inFiles(Finder finder) =>
      find.descendant(of: find.byType(FilesPage), matching: finder);
  File file(String name) => File(p.normalize(p.join(root.path, name)));

  Future<void> start() async {
    root = Directory.systemTemp.createTempSync('case-');
    await RulePersistence.saveRules([]);
    await Shared.pref.setString('file_or_dir', 'Files & Dirs');
    for (final key in ['only_selected', 'remove_renamed', 'remove_rules']) {
      await Shared.pref.setBool(key, false);
    }
    await Shared.init();
    await tester.binding.setSurfaceSize(const Size(1600, 1000));
    await tester.pumpWidget(const app.RenamerApp(locale: Locale('en')));
    await tester.pumpAndSettle();
  }

  Future<FileEntity> addFile(String name, [String content = 'payload']) async {
    file(name).writeAsStringSync(content);
    final entity = FileEntity(file(name));
    FilesPage.addFiles([entity]);
    files.update();
    await tester.pumpAndSettle();
    return entity;
  }

  Future<void> addRule(Rule rule) async {
    rules.addRule(rule);
    await saved();
    await tester.pumpAndSettle();
  }

  Future<void> saved() async {
    final expected = rules.rules.map((r) => r.toMap()).toList();
    for (var attempt = 0; attempt < 150; attempt++) {
      await tester.pump(const Duration(milliseconds: 50));
      final actual =
          (await RulePersistence.loadRules()).map((r) => r.toMap()).toList();
      if (equals(expected).matches(actual, {})) return;
    }
    fail('Rules did not reach native persistent storage.');
  }

  Future<void> tapRename() async {
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();
  }

  Future<void> until(bool Function() condition) async {
    for (var attempt = 0; attempt < 150; attempt++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (condition()) return;
    }
    fail('Timed out waiting for the expected app/filesystem state.');
  }

  Future<void> close() async {
    await Logger().flush();
    if (find.byType(FilesPage).evaluate().isNotEmpty) {
      await tester.tap(inFiles(find.byTooltip(L10n.current.removeAll)));
      await tester.tap(
        find.descendant(
          of: find.byType(RulesPage),
          matching: find.byTooltip(L10n.current.removeAll),
        ),
      );
      await saved();
    }
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.binding.setSurfaceSize(null);
  }
}

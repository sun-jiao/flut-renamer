import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/pages/home_page.dart';
import 'package:flut_renamer/pages/rules_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/file_metadata.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() async {
    await L10n.load(const Locale('en'));
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('renamer_lock_');
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

  for (final failPreview in [false, true]) {
    testWidgets(
        'locks list edits while preparing rename and unlocks after '
        '${failPreview ? 'failure' : 'success'}', (tester) async {
      final first = File('${directory.path}/first.txt')
        ..writeAsStringSync('first');
      final second = File('${directory.path}/second.txt')
        ..writeAsStringSync('second');
      File('${directory.path}/late.txt').writeAsStringSync('late');
      final key = GlobalKey<FilesPageState>();
      FilesPage.addFiles([FileEntity(first), FileEntity(second)]);
      var lockedRows = 0;
      var dropEnabled = true;
      var focusedWhileLocked = true;

      await tester.runAsync(() async {
        final ready = Completer<String>();
        await tester.pumpWidget(
          _page(
            key,
            (name, _) {
              if (name == 'first.txt') return ready.future;
              return 'second-new.txt';
            },
          ),
        );
        await tester.tap(find.byType(TextField));
        await tester.pump();
        final filter = tester.widget<EditableText>(find.byType(EditableText));
        expect(filter.focusNode.hasFocus, isTrue);
        final staleDrop = tester.widget<DropTarget>(find.byType(DropTarget));

        final pending = key.currentState!.renameFiles(remove: false);
        try {
          await tester.pump();
          await tester.tap(find.byIcon(Icons.delete).last, warnIfMissed: false);
          await tester.tap(
            find.byTooltip(L10n.current.removeAll),
            warnIfMissed: false,
          );
          // Native drops can finish after the operation has already started.
          staleDrop.onDragDone!(
            DropDoneDetails(
              files: [DropItemFile('${directory.path}/late.txt')],
              localPosition: Offset.zero,
              globalPosition: Offset.zero,
            ),
          );
          await tester.pump();
          lockedRows = find.byType(Checkbox).evaluate().length;
          dropEnabled =
              tester.widget<DropTarget>(find.byType(DropTarget)).enable;
          focusedWhileLocked = filter.focusNode.hasFocus;
        } finally {
          if (failPreview) {
            ready.completeError(
              const FormatException('Injected preview failure'),
            );
          } else {
            ready.complete('first-new.txt');
          }
          await pending;
          await Logger().flush();
        }
      });

      await tester.pump();
      final rowsAfterRename = find.byType(Checkbox).evaluate().length;
      // A completed or rejected operation must restore normal list controls.
      await tester.tap(find.byTooltip(L10n.current.removeAll));
      await tester.pump();
      expect(find.byType(Checkbox), findsOneWidget);
      expect(
        lockedRows,
        3,
        reason: 'Neither remove button may edit the active plan',
      );
      expect(rowsAfterRename, 3);
      expect(dropEnabled, isFalse);
      expect(focusedWhileLocked, isFalse);
      expect(
        File('${directory.path}/first-new.txt').existsSync(),
        !failPreview,
      );
      expect(
        File('${directory.path}/second-new.txt').existsSync(),
        !failPreview,
      );
      expect(first.existsSync(), failPreview);
      expect(second.existsSync(), failPreview);
      expect(
        File('${directory.path}/${failPreview ? 'first' : 'first-new'}.txt')
            .readAsStringSync(),
        'first',
      );
      expect(
        File('${directory.path}/${failPreview ? 'second' : 'second-new'}.txt')
            .readAsStringSync(),
        'second',
      );
    });
  }

  testWidgets('a pending rule update cancels preparation before any file moves',
      (tester) async {
    final source = File('${directory.path}/before.txt')
      ..writeAsStringSync('source');
    final key = GlobalKey<FilesPageState>();
    FilesPage.addFiles([FileEntity(source)]);

    await tester.runAsync(() async {
      final ready = Completer<String>();
      await tester.pumpWidget(_page(key, (name, metadata) => ready.future));
      final pending = key.currentState!.renameFiles(remove: false);
      // Simulate a rule import that was already in flight when rename started.
      key.currentState!.update();
      ready.complete('after.txt');
      await pending;
    });

    await tester.pump();
    await tester.tap(find.byTooltip(L10n.current.removeAll));
    await tester.pump();
    expect(find.byType(Checkbox), findsOneWidget);
    expect(source.readAsStringSync(), 'source');
    expect(File('${directory.path}/after.txt').existsSync(), isFalse);
  });

  testWidgets('home locks rules and settings and shows progress during rename',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final source = File('${directory.path}/before.txt')
      ..writeAsStringSync('source');
    FilesPage.addFiles([FileEntity(source)]);
    var rulesWhileLocked = 0;
    var thumbnailsWhileLocked = true;
    var renameEnabledWhileLocked = true;
    var progressWhileLocked = false;

    await tester.runAsync(() async {
      final ready = Completer<String>();
      await tester.pumpWidget(_app(const HomePage()));
      final rules = tester.state<RulesPageState>(find.byType(RulesPage));
      final files = tester.state<FilesPageState>(find.byType(FilesPage));
      rules.rules
        ..clear()
        ..add(_WaitingRule(ready.future));
      files.update();
      final pending = files.renameFiles(remove: false);
      try {
        await tester.pump();
        await tester.tap(
          find.descendant(
            of: find.byType(RulesPage),
            matching: find.byTooltip(L10n.current.removeAll),
          ),
          warnIfMissed: false,
        );
        await tester.tap(
          find.byTooltip(L10n.current.showThumbnails).first,
          warnIfMissed: false,
        );
        rulesWhileLocked = rules.rules.length;
        thumbnailsWhileLocked = Shared.showThumbnails;
        renameEnabledWhileLocked = tester
                .widget<FloatingActionButton>(find.byType(FloatingActionButton))
                .onPressed !=
            null;
        progressWhileLocked =
            find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      } finally {
        ready.complete('after.txt');
        await pending;
        await Logger().flush();
        rules.rules.clear();
      }
    });

    await tester.pump();
    expect(
      tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton))
          .onPressed,
      isNotNull,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(
      find.descendant(
        of: find.byType(FilesPage),
        matching: find.byTooltip(L10n.current.removeAll),
      ),
    );
    await tester.pump();
    expect(rulesWhileLocked, 1);
    expect(thumbnailsWhileLocked, isFalse);
    expect(renameEnabledWhileLocked, isFalse);
    expect(progressWhileLocked, isTrue);
    expect(File('${directory.path}/after.txt').readAsStringSync(), 'source');
  });
}

Widget _page(
  GlobalKey<FilesPageState> key,
  FutureOr<String> Function(String, FileMetadata) getNewName,
) =>
    _app(
      Scaffold(
        body: FilesPage(
          key: key,
          getNewName: getNewName,
          clearRules: () {},
          resetRules: () {},
          dependsOnFileOrder: () => false,
          requiresMetadata: () => true,
        ),
      ),
    );

Widget _app(Widget home) => MaterialApp(
      theme: ThemeData(
        extensions: [
          FileListColors(
            primaryColor: Colors.white,
            secondaryColor: Colors.grey,
          ),
        ],
      ),
      home: home,
    );

class _WaitingRule extends RuleInsert {
  _WaitingRule(this.result) : super('', 0, false, false, false);

  final Future<String> result;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) => result;
}

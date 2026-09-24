import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/main.dart' as app;
import 'package:flut_renamer/pages/files_page.dart';
import 'package:flut_renamer/pages/rules_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/atomic_rename.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:flut_renamer/tools/platform_channel.dart';
import 'package:flut_renamer/tools/rename_transaction.dart';
import 'package:flut_renamer/tools/rule_persistence.dart';

import 'support/environment.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  File file(String name) => File(p.normalize(p.join(root.path, name)));
  setUpAll(() async {
    await requireTestEnvironment();
    await L10n.load(const Locale('en'));
    await Shared.init();
  });
  setUp(() async {
    final temporary = await getTemporaryDirectory();
    await temporary.create(recursive: true);
    root = await temporary.createTemp('platform-case-');
    final ownedRoot = root;
    // Register only after creation succeeds; failed setup has no root to clean.
    addTearDown(() async {
      await Logger().flush();
      if (await ownedRoot.exists()) await ownedRoot.delete(recursive: true);
    });
  });

  testWidgets('native plugin registration and writable app directories',
      (tester) async {
    final info = await PackageInfo.fromPlatform();
    expect(info.packageName, isNotEmpty);
    expect(info.version, isNotEmpty);
    for (final directory in [
      await getApplicationSupportDirectory(),
      await getApplicationCacheDirectory(),
    ]) {
      await directory.create(recursive: true);
      final probe = await directory.createTemp('plugin-probe-');
      try {
        final data = File(p.join(probe.path, 'data'));
        await data.writeAsBytes([0, 127, 255], flush: true);
        expect(await data.readAsBytes(), [0, 127, 255]);
      } finally {
        await probe.delete(recursive: true);
      }
    }
  });

  testWidgets('native preferences can be persisted, reloaded and removed',
      (tester) async {
    const key = 'integration_native_probe';
    try {
      expect(await Shared.pref.setString(key, '中文 value'), isTrue);
      await Shared.pref.reload();
      expect(Shared.pref.getString(key), '中文 value');
      expect(await Shared.pref.remove(key), isTrue);
      await Shared.pref.reload();
      expect(Shared.pref.containsKey(key), isFalse);
    } finally {
      await Shared.pref.remove(key);
    }
  });

  testWidgets('native unicode and case-only rename preserve bytes',
      (tester) async {
    final source = file('照片-file.txt')..writeAsBytesSync([0, 1, 128, 255]);
    final renamed =
        await atomicRenameNoReplace(source, file('照片-FILE.txt').path);
    expect(await File(renamed.path).readAsBytes(), [0, 1, 128, 255]);
    expect(root.listSync().map((e) => p.basename(e.path)), ['照片-FILE.txt']);
  });

  for (final directoryTarget in [false, true]) {
    testWidgets(
        'native no-replace reports OS error for directory=$directoryTarget',
        (tester) async {
      final source = file('source')..writeAsStringSync('original');
      if (directoryTarget) {
        Directory(file('target').path).createSync();
      } else {
        file('target').writeAsStringSync('external');
      }
      await expectLater(
        atomicRenameNoReplace(source, file('target').path),
        throwsA(
          isA<FileSystemException>().having(
            (e) => e.osError?.errorCode,
            'native error code',
            greaterThan(0),
          ),
        ),
      );
      expect(source.readAsStringSync(), 'original');
      if (!directoryTarget) {
        expect(file('target').readAsStringSync(), 'external');
      }
      expect(root.listSync(), hasLength(2));
    });
  }

  testWidgets(
      'native missing source reports an OS error without creating target',
      (tester) async {
    await expectLater(
      atomicRenameNoReplace(file('missing'), file('target').path),
      throwsA(
        isA<FileSystemException>().having(
          (e) => e.osError?.errorCode,
          'native error code',
          greaterThan(0),
        ),
      ),
    );
    expect(root.listSync(), isEmpty);
  });

  testWidgets(
    'Windows rename preserves error codes across FFI calls',
    (tester) async {
      final target = file('target')..writeAsStringSync('external');
      Matcher windowsError(int code) => throwsA(
            isA<FileSystemException>().having(
              (e) => e.osError?.errorCode,
              'Windows error code',
              code,
            ),
          );

      // Exercise cold and warmed-up FFI calls, including success after failure
      // and failure after success. Error values must belong to the current move.
      for (var index = 0; index < 10; index++) {
        final source = file('source-$index')
          ..writeAsStringSync('original-$index');
        await expectLater(
          atomicRenameNoReplace(source, target.path),
          windowsError(183), // ERROR_ALREADY_EXISTS
        );
        expect(source.readAsStringSync(), 'original-$index');
        expect(target.readAsStringSync(), 'external');

        final moved =
            await atomicRenameNoReplace(source, file('moved-$index').path);
        expect(File(moved.path).readAsStringSync(), 'original-$index');
        expect(source.existsSync(), isFalse);
        await expectLater(
          atomicRenameNoReplace(source, file('unused').path),
          windowsError(2), // ERROR_FILE_NOT_FOUND
        );
        expect(file('unused').existsSync(), isFalse);
      }
      expect(root.listSync(), hasLength(11));
    },
    skip: !Platform.isWindows,
  );

  testWidgets('native swap transaction leaves no temporary files',
      (tester) async {
    file('a').writeAsStringSync('a');
    file('b').writeAsStringSync('b');
    final result = await commitRenameTransaction([
      FileEntity(file('a'), newName: 'b'),
      FileEntity(file('b'), newName: 'a'),
    ]);
    expect(result.succeeded, isTrue);
    expect(file('a').readAsStringSync(), 'b');
    expect(file('b').readAsStringSync(), 'a');
    expect(root.listSync(), hasLength(2));
  });

  testWidgets('native parent and child transaction updates returned paths',
      (tester) async {
    final parent = Directory(file('folder').path)..createSync();
    final child = file('folder/child.txt')..writeAsStringSync('child');
    final result = await commitRenameTransaction([
      FileEntity(parent, newName: 'new-folder'),
      FileEntity(child, newName: 'new.txt'),
    ]);
    expect(result.succeeded, isTrue);
    expect(result.entities.last.path, file('new-folder/new.txt').path);
    expect(file('new-folder/new.txt').readAsStringSync(), 'child');
  });

  testWidgets('native YAML and audit log round trip', (tester) async {
    final rules = [
      RuleInsert('前缀-', 0, false, false, true),
      RuleIncrement('file', 1, 1, false, true),
    ];
    await RulePersistence.saveRules(rules, targetFile: file('rules.yaml'));
    expect(
      (await RulePersistence.loadRules(sourceFile: file('rules.yaml')))
          .map((e) => e.toMap()),
      rules.map((e) => e.toMap()),
    );
    await Logger().clearLogs();
    await Logger().logRename(file('before').path, file('after').path);
    expect(await Logger().readLogs(), contains(file('after').path));
    await Logger().clearLogs();
    expect(await Logger().readLogs(), isEmpty);
  });

  testWidgets(
    'app action renames an app-private file on the native device',
    (tester) async {
      await RulePersistence.saveRules([]);
      Shared.removeRenamed = false;
      Shared.removeRules = false;
      Shared.onlySelected = false;
      Shared.fileOrDir = 'Files';
      Shared.doNotRemindAgain = true;
      final source = file('source.txt')..writeAsStringSync('native UI');
      await tester.pumpWidget(const app.RenamerApp(locale: Locale('en')));
      await tester.pumpAndSettle();
      final files = tester.state<FilesPageState>(find.byType(FilesPage));
      final rules = tester.state<RulesPageState>(find.byType(RulesPage));
      FilesPage.addFiles([FileEntity(source)]);
      files.update();
      rules.addRule(RuleInsert('new-', 0, false, false, true));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      for (var i = 0; i < 100 && !file('new-source.txt').existsSync(); i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(file('new-source.txt').readAsStringSync(), 'native UI');
      expect(source.existsSync(), isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  if (Platform.isAndroid) {
    // Direct channel checks must not be masked by Dart's fallback handling.
    const channel = MethodChannel('net.sunjiao.renamer/picker');
    testWidgets('Android empty media request completes without prompting',
        (tester) async {
      final result = await channel.invokeMapMethod<String, dynamic>(
        'requestMediaWritePermission',
        {'uris': <String>[]},
      );
      expect(result, {'candidates': [], 'approved': []});
    });
  }
  if (Platform.isIOS) {
    testWidgets(
        'iOS refuses unselected external scopes and cleanup is idempotent',
        (tester) async {
      expect(
        await PlatformFilePicker.changeScopedAccess(
          '/unselected-external-folder',
          true,
        ),
        isFalse,
      );
      await PlatformFilePicker.retainScopedAccess([]);
      await PlatformFilePicker.retainScopedAccess([]);
      expect(
        await PlatformFilePicker.changeScopedAccess(
          '/unselected-external-folder',
          false,
        ),
        isTrue,
      );
    });
    testWidgets('iOS scoped-access channel completes start and stop',
        (tester) async {
      // App-private URLs need no grant: this verifies channel wiring, not a
      // user-selected external security-scoped resource authorization.
      expect(
        await PlatformFilePicker.changeScopedAccess(root.path, true),
        isTrue,
      );
      expect(
        await PlatformFilePicker.changeScopedAccess(root.path, false),
        isTrue,
      );
    });
  }
}

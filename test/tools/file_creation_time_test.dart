import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/file_creation_time.dart';
import 'package:flut_renamer/tools/file_metadata.dart';

void main() {
  test(
    'local birth time survives content, metadata and path changes',
    () async {
      final root = await Directory.systemTemp.createTemp('renamer_birth_');
      addTearDown(() => root.delete(recursive: true));
      final file = await File('${root.path}/before').writeAsString('before');
      final stat = await file.stat();
      final created = await readFileCreationTime(file.path, stat);
      if (Platform.isLinux) {
        // An independent native tool confirms both support and the timestamp.
        final native = await Process.run('stat', ['--format=%W', file.path]);
        expect(native.exitCode, 0);
        final seconds = int.parse((native.stdout as String).trim());
        expect(
          (created?.millisecondsSinceEpoch ?? 0) ~/ 1000,
          seconds,
        );
      } else {
        expect(created, stat.changed);
      }
      final before = FileMetadata(file);
      await before.init();
      // Move ctime into another second so the formatted tag catches the old bug.
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      await file.writeAsString('after');
      await file.setLastModified(DateTime(2000));
      final renamed = await file.rename('${root.path}/after');
      final afterStat = await renamed.stat();
      expect(afterStat.modified.year, 2000);
      if (Platform.isLinux) expect(afterStat.changed, isNot(stat.changed));
      expect(await readFileCreationTime(renamed.path, afterStat), created);
      final after = FileMetadata(renamed);
      await after.init();
      expect(
        after.getByName('File:CreateTime'),
        before.getByName('File:CreateTime'),
      );
      expect(after.getByName('File:ModifyDate'), '2000-01-01');
    },
    skip: !Platform.isLinux && !Platform.isWindows,
  );

  test('missing paths and content URIs have no invented birth time', () async {
    final root = await Directory.systemTemp.createTemp('renamer_birth_');
    addTearDown(() => root.delete(recursive: true));
    final missing = '${root.path}/missing';
    expect(
      await readFileCreationTime(missing, await FileStat.stat(missing)),
      isNull,
    );
    expect(
      await readFileCreationTime(
        'content://provider/file',
        await root.stat(),
      ),
      isNull,
    );
  });

  test(
    'Linux filesystems without birth time return no creation tags',
    () async {
      final file = File('/proc/version');
      expect(await readFileCreationTime(file.path, await file.stat()), isNull);
      final metadata = FileMetadata(file);
      await metadata.init();
      expect(metadata.getByName('File:CreateDate'), isEmpty);
      expect(metadata.getByName('File:CreateTime'), isEmpty);
      expect(metadata.getByName('File:ModifyDate'), isNotEmpty);
    },
    skip: !Platform.isLinux,
  );
}

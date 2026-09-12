import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/atomic_rename.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('atomic_rename_');
  });

  tearDown(() => directory.delete(recursive: true));

  test('renames a file when the destination does not exist', () async {
    final source = File('${directory.path}/source.txt');
    await source.writeAsString('source');

    final result =
        await atomicRenameNoReplace(source, '${directory.path}/new.txt');

    expect(result, isA<File>());
    expect(await File('${directory.path}/new.txt').readAsString(), 'source');
    expect(await source.exists(), isFalse);
  });

  test('fails without replacing an existing destination', () async {
    final source = File('${directory.path}/source.txt');
    final destination = File('${directory.path}/destination.txt');
    await source.writeAsString('source');
    await destination.writeAsString('destination');

    await expectLater(
      atomicRenameNoReplace(source, destination.path),
      throwsA(isA<FileSystemException>()),
    );
    expect(await source.readAsString(), 'source');
    expect(await destination.readAsString(), 'destination');
  });
}

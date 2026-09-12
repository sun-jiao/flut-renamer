import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/rename_transaction.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('renamer_transaction_');
  });

  tearDown(() => temporaryDirectory.delete(recursive: true));

  test('rolls back completed renames when a later rename fails', () async {
    final first = File('${temporaryDirectory.path}/first.txt');
    final second = File('${temporaryDirectory.path}/second.txt');
    await first.writeAsString('first');
    await second.writeAsString('second');
    final files = [
      FileEntity(first, newName: 'first-new.txt'),
      FileEntity(second, newName: 'second-new.txt'),
    ];
    var calls = 0;

    final result = await commitRenameTransaction(
      files,
      operation: (file, _) async {
        calls++;
        if (calls == 2) return null;
        final renamed = await file.entity.rename(file.newPath);
        return FileEntity(renamed);
      },
    );

    expect(result.succeeded, isFalse);
    expect(await first.readAsString(), 'first');
    expect(await second.readAsString(), 'second');
    expect(result.entities.map((file) => file.path), [first.path, second.path]);
    expect(calls, 3);
  });

  test('rescans the renamed path when rollback fails', () async {
    final source = File('${temporaryDirectory.path}/source.txt');
    final failing = File('${temporaryDirectory.path}/failing.txt');
    await source.writeAsString('source');
    await failing.writeAsString('failing');
    final files = [
      FileEntity(source, newName: 'renamed.txt'),
      FileEntity(failing, newName: 'never.txt'),
    ];
    var calls = 0;

    final result = await commitRenameTransaction(
      files,
      operation: (file, _) async {
        calls++;
        if (calls > 1) return null;
        return FileEntity(await file.entity.rename(file.newPath));
      },
    );

    expect(result.succeeded, isFalse);
    expect(
      result.entities.first.path,
      '${temporaryDirectory.path}/renamed.txt',
    );
    expect(await File(result.entities.first.path).readAsString(), 'source');
  });

  test('uses temporary names to swap two files', () async {
    final first = File('${temporaryDirectory.path}/first.txt');
    final second = File('${temporaryDirectory.path}/second.txt');
    await first.writeAsString('first');
    await second.writeAsString('second');
    final files = [
      FileEntity(first, newName: 'second.txt'),
      FileEntity(second, newName: 'first.txt'),
    ];

    final result = await commitRenameTransaction(
      files,
      operation: (file, _) async => FileEntity(
        await file.entity.rename(file.newPath),
      ),
    );

    expect(result.succeeded, isTrue);
    expect(await first.readAsString(), 'second');
    expect(await second.readAsString(), 'first');
    expect(result.entities.map((file) => file.path), [second.path, first.path]);
  });

  test('uses temporary names for a three-file rename cycle', () async {
    final first = File('${temporaryDirectory.path}/first.txt');
    final second = File('${temporaryDirectory.path}/second.txt');
    final third = File('${temporaryDirectory.path}/third.txt');
    await first.writeAsString('first');
    await second.writeAsString('second');
    await third.writeAsString('third');
    final files = [
      FileEntity(first, newName: 'second.txt'),
      FileEntity(second, newName: 'third.txt'),
      FileEntity(third, newName: 'first.txt'),
    ];

    final result = await commitRenameTransaction(
      files,
      operation: (file, _) async => FileEntity(
        await file.entity.rename(file.newPath),
      ),
    );

    expect(result.succeeded, isTrue);
    expect(await first.readAsString(), 'third');
    expect(await second.readAsString(), 'first');
    expect(await third.readAsString(), 'second');
    expect(result.entities.map((file) => file.path), [
      second.path,
      third.path,
      first.path,
    ]);
  });

  test('renames a selected child before its directory ancestor', () async {
    final directory = Directory('${temporaryDirectory.path}/folder');
    await directory.create();
    final child = File('${directory.path}/a.txt');
    await child.writeAsString('contents');
    final files = [
      FileEntity(directory, newName: 'renamed-folder'),
      FileEntity(child, newName: 'b.txt'),
    ];

    final result = await commitRenameTransaction(
      files,
      operation: (file, _) async => FileEntity(
        await file.entity.rename(file.newPath),
      ),
    );

    final renamedDirectory =
        Directory('${temporaryDirectory.path}/renamed-folder');
    final renamedChild = File('${renamedDirectory.path}/b.txt');
    expect(result.succeeded, isTrue);
    expect(await renamedChild.readAsString(), 'contents');
    expect(result.entities.map((file) => file.path), [
      renamedDirectory.path,
      renamedChild.path,
    ]);
  });
}

import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/ex_string.dart';
import 'package:flut_renamer/tools/file_sort.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('renamer_ex_file_');
  });

  tearDown(() => directory.delete(recursive: true));

  test(
      'identifies files, directories, links, duplicate destinations, and paths',
      () async {
    final file = File('${directory.path}/source.txt');
    final folder = Directory('${directory.path}/folder');
    await file.writeAsString('contents');
    await folder.create();
    final link = Link('${directory.path}/source-link');
    await link.create(file.path);

    final first = FileEntity(file, newName: 'renamed.txt');
    final duplicate =
        FileEntity(File('${directory.path}/other.txt'), newName: 'renamed.txt');
    expect(first.fileOrDir(), 'File');
    expect(FileEntity(folder).fileOrDir(), 'Dir');
    expect(FileEntity(link).fileOrDir(true), 'Link');
    expect(first.newPath, '${directory.path}/renamed.txt');
    expect(first.isNewNameDuplicate([first, duplicate]), isTrue);
  });

  test('creates accessible filename semantics and replaces only the last match',
      () {
    expect('IMG2024-01.jpg'.toFilenameSemanticLabel(), 'IMG，2024，-，01.j，pg');
    expect(
      'a-1-a-2'.replaceLastMapped('a', (match) => 'x'),
      'a-1-x-2',
    );
  });

  test('missing paths are files, not fabricated links', () {
    final path = '${directory.path}/missing.txt';
    final entities = [
      path.toFileEntity(),
      XFile(path).toFileEntity(),
    ];
    for (final entity in entities) {
      expect(entity.entity, isA<File>());
      expect(entity.path, path);
      expect(entity.existsSync(), isFalse);
      expect(entity.fileOrDir(), 'File');
    }
  });

  group(
    'symbolic links',
    () {
      test('dangling links remain visible without reading missing targets', () {
        final link = Link('${directory.path}/dangling')..createSync('missing');
        final entities = [
          link.path.toFileEntity(),
          XFile(link.path).toFileEntity(),
        ];
        for (final entity in entities) {
          expect(entity.entity, isA<Link>());
          expect(entity.path, link.path);
          expect(entity.existsSync(), isTrue);
          expect(entity.fileOrDir(), 'File');
          expect(entity.fileOrDir(true), 'Link');
        }
        expect(link.targetSync(), 'missing');
      });

      test('relative links retain identity and filter by their target type',
          () {
        File('${directory.path}/target.txt').writeAsStringSync('target');
        Directory('${directory.path}/folder').createSync();
        for (final entry in {'target.txt': 'File', 'folder': 'Dir'}.entries) {
          final link = Link('${directory.path}/${entry.key}-link')
            ..createSync(entry.key);
          final entity = link.path.toFileEntity();
          expect(entity.entity, isA<Link>());
          expect(entity.path, link.path);
          expect(entity.fileOrDir(), entry.value);
          expect(entity.fileOrDir(true), 'Link');
        }
      });

      test('link chains resolve relative targets from each link directory', () {
        Directory('${directory.path}/nested').createSync();
        File('${directory.path}/target.txt').writeAsStringSync('target');
        Link('${directory.path}/nested/second').createSync('../target.txt');
        final first = Link('${directory.path}/first')
          ..createSync('nested/second');
        expect(first.path.toFileEntity().fileOrDir(), 'File');
        expect(
          (first.toFileSystemEntity() as File).readAsStringSync(),
          'target',
        );
      });

      test('cyclic links do not loop during classification', () {
        final first = Link('${directory.path}/first');
        final second = Link('${directory.path}/second');
        first.createSync(second.path);
        second.createSync(first.path);
        expect(first.path.toFileEntity().fileOrDir(), 'File');
        expect(
          first.toFileSystemEntity,
          throwsA(isA<FileSystemException>()),
        );
      });

      test('removing a target or link does not break classification', () {
        final target = File('${directory.path}/target.txt')
          ..writeAsStringSync('target');
        final link = Link('${directory.path}/link')..createSync(target.path);
        final entity = link.path.toFileEntity();
        target.deleteSync();
        expect(entity.fileOrDir(), 'File');
        expect(entity.existsSync(), isTrue);
        link.deleteSync();
        expect(entity.fileOrDir(), 'File');
        expect(entity.existsSync(), isFalse);
      });
    },
    skip: Platform.isWindows,
  ); // Link creation requires Windows privileges.

  test('sorts by extension and falls back to the full filename on ties', () {
    final a = FileEntity(File('${directory.path}/zeta.txt'));
    final b = FileEntity(File('${directory.path}/alpha.txt'));
    final image = FileEntity(File('${directory.path}/image.jpg'));
    expect(compareFiles(a, b, FileSortField.type), greaterThan(0));
    expect(compareFiles(image, a, FileSortField.type), lessThan(0));
  });
}

import 'dart:io';

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

  test('sorts by extension and falls back to the full filename on ties', () {
    final a = FileEntity(File('${directory.path}/zeta.txt'));
    final b = FileEntity(File('${directory.path}/alpha.txt'));
    final image = FileEntity(File('${directory.path}/image.jpg'));
    expect(compareFiles(a, b, FileSortField.type), greaterThan(0));
    expect(compareFiles(image, a, FileSortField.type), lessThan(0));
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/file_sort.dart';

void main() {
  group('compareNaturally', () {
    test('puts an unnumbered filename before numbered variants', () {
      final filenames = <String>[
        '文件名(20)',
        '文件名(01)',
        '文件名',
        '文件名(2)',
      ];

      filenames.sort(compareNaturally);

      expect(filenames, [
        '文件名',
        '文件名(01)',
        '文件名(2)',
        '文件名(20)',
      ]);
    });

    test('compares numeric runs by value instead of text order', () {
      final filenames = <String>['clip10', 'clip2', 'clip1'];

      filenames.sort(compareNaturally);

      expect(filenames, ['clip1', 'clip2', 'clip10']);
    });

    test('compares numeric runs beyond the native integer range', () {
      final filenames = <String>[
        'clip999999999999999999999999999999999999',
        'clip1000000000000000000000000000000000000',
        'clip0000000000000000000000000000000000001',
      ];

      filenames.sort(compareNaturally);

      expect(filenames, [
        'clip0000000000000000000000000000000000001',
        'clip999999999999999999999999999999999999',
        'clip1000000000000000000000000000000000000',
      ]);
    });

    test('is case-insensitive while preserving a deterministic short-name tie',
        () {
      expect(compareNaturally('PHOTO2', 'photo10'), lessThan(0));
      expect(compareNaturally('file', 'file1'), lessThan(0));
    });
  });

  group('file metadata sorting', () {
    late Directory directory;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('file_sort_test_');
    });

    tearDown(() => directory.delete(recursive: true));

    test('uses asynchronously cached sizes instead of name order', () async {
      final larger = FileEntity(File('${directory.path}/a-large'));
      final smaller = FileEntity(File('${directory.path}/z-small'));
      await (larger.entity as File).writeAsBytes(List<int>.filled(10, 0));
      await (smaller.entity as File).writeAsBytes([0]);

      await preloadFileSortMetadata([larger, smaller]);

      expect(compareFiles(larger, smaller, FileSortField.size), greaterThan(0));
    });

    test('uses asynchronously cached modification dates instead of name order',
        () async {
      final newer = FileEntity(File('${directory.path}/a-newer'));
      final older = FileEntity(File('${directory.path}/z-older'));
      await (newer.entity as File).writeAsString('new');
      await (older.entity as File).writeAsString('old');
      await (newer.entity as File).setLastModified(DateTime(2025));
      await (older.entity as File).setLastModified(DateTime(2020));

      await preloadFileSortMetadata([newer, older]);

      expect(compareFiles(newer, older, FileSortField.date), greaterThan(0));
    });

    test('falls back to names when metadata has not been preloaded', () {
      final zeta = FileEntity(File('${directory.path}/zeta.txt'));
      final alpha = FileEntity(File('${directory.path}/alpha.txt'));

      expect(compareFiles(zeta, alpha, FileSortField.size), greaterThan(0));
      expect(compareFiles(zeta, alpha, FileSortField.date), greaterThan(0));
    });

    test('sorts by extension and then by full file name', () {
      final first = FileEntity(File('${directory.path}/zeta.jpg'));
      final second = FileEntity(File('${directory.path}/alpha.jpg'));
      final third = FileEntity(File('${directory.path}/photo.png'));

      expect(compareFiles(first, third, FileSortField.type), lessThan(0));
      expect(compareFiles(first, second, FileSortField.type), greaterThan(0));
    });
  });
}

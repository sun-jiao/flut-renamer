import 'package:flutter_test/flutter_test.dart';
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
  });
}

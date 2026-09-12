import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  group('splitFileName', () {
    test('separates only the final extension when requested', () {
      expect(splitFileName('archive.tar.gz', true), ('archive.tar', '.gz'));
    });

    test('does not treat a hidden file name as an extension', () {
      expect(splitFileName('.env', true), ('.env', ''));
    });

    test('keeps the complete name when extension handling is disabled', () {
      expect(splitFileName('photo.jpg', false), ('photo.jpg', ''));
    });
  });
}

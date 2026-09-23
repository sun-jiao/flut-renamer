library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  test('removes a fixed-length suffix from filenames of different lengths', () {
    final rule = RuleTruncate(16, 0, true, true, true, false);

    expect(rule.newName('filename1_standard_suffix.ext'), 'filename1.ext');
    expect(
      rule.newName('filename2-with-different-namelenght_standard_suffix.ext'),
      'filename2-with-different-namelenght.ext',
    );
  });

  test('zero is the end boundary and two selects the final two characters', () {
    expect(
      RuleTruncate(2, 0, true, true, true, false).newName('abcdef.txt'),
      'abcd.txt',
    );
    expect(
      RuleTruncate(0, 2, true, true, true, false).newName('abcdef.txt'),
      'abcd.txt',
    );
  });

  test('can keep from the beginning to an end-relative boundary', () {
    expect(
      RuleTruncate(0, 2, false, true, true, true).newName('abcdef.txt'),
      'abcd.txt',
    );
  });

  test('still removes a prefix when counting from the beginning', () {
    expect(
      RuleTruncate(0, 2, false, false, true, false).newName('abcdef.txt'),
      'cdef.txt',
    );
  });

  test('clamps suffix removal to the filename length', () {
    expect(
      RuleTruncate(20, 0, true, true, true, false).newName('abc.txt'),
      '.txt',
    );
  });

  test('keeps characters using positive offsets from the end', () {
    final result = RuleTruncate(
      3,
      0,
      true,
      true,
      true,
      true,
    ).newName('abcdef.txt');

    expect(result, 'def.txt');
  });

  test('clamps out-of-bounds offsets before truncating', () {
    final result = RuleTruncate(
      0,
      20,
      false,
      true,
      true,
      true,
    ).newName('abcdef.txt');

    expect(result, '.txt');
  });

  test('removes a range and handles reversed indices', () {
    expect(
      RuleTruncate(4, 1, false, false, true, false).newName('abcdef.txt'),
      'aef.txt',
    );
  });

  test('can include the extension in the truncated range', () {
    expect(
      RuleTruncate(1, 4, false, false, false, true).newName('abc.txt'),
      'bc.',
    );
  });

  test('serializes and restores every option', () {
    final rule = RuleTruncate(1, 5, true, false, false, false);
    final restored = RuleFactory.fromMap(rule.toMap()) as RuleTruncate;
    expect(restored.index1, 1);
    expect(restored.index2, 5);
    expect(restored.i1toEnd, isTrue);
    expect(restored.i2toEnd, isFalse);
    expect(restored.ignoreExtension, isFalse);
    expect(restored.keepBetween, isFalse);
  });
}

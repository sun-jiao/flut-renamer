library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
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

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
}

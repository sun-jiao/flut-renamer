import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  test('removes all matching text while preserving the extension', () async {
    final rule = RuleRemove('file', 0, false, false, true);
    expect(await rule.newName('file_FILE_file.txt'), '__.txt');
  });

  test('removes matches counted from the end', () async {
    final rule = RuleRemove('_', -2, true, false, true);
    expect(await rule.newName('a_b_c_d.txt'), 'a_bcd.txt');
  });

  test('supports regular expressions and serialization', () async {
    final rule = RuleRemove(r'\d+', 1, true, true, false);
    expect(await rule.newName('a12b34.txt'), 'ab34.txt');

    final restored = RuleFactory.fromMap(rule.toMap()) as RuleRemove;
    expect(restored.targetString, r'\d+');
    expect(restored.ruleReplace.replaceLimit, 1);
    expect(restored.ruleReplace.caseSensitive, isTrue);
    expect(restored.ruleReplace.ignoreExtension, isFalse);
  });
}

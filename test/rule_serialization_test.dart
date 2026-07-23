import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/entity/transliterate.dart';

void main() {
  test('RuleReplace serialization', () {
    final rule = RuleReplace('target', 'replacement', 1, false, true, false, true);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleReplace;
    
    expect(restored.targetString, 'target');
    expect(restored.replacementString, 'replacement');
    expect(restored.replaceLimit, 1);
    expect(restored.withMetadata, false);
    expect(restored.caseSensitive, true);
    expect(restored.isRegex, false);
    expect(restored.ignoreExtension, true);
  });

  test('RuleRemove serialization', () {
    final rule = RuleRemove('target', 0, false, true, false);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleRemove;
    
    expect(restored.targetString, 'target');
    expect(restored.ruleReplace.replaceLimit, 0);
    expect(restored.ruleReplace.isRegex, true);
  });

  test('RuleInsert serialization', () {
    final rule = RuleInsert('prefix', 5, true, false, true);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleInsert;
    
    expect(restored.insert, 'prefix');
    expect(restored.insertIndex, 5);
    expect(restored.toEnd, true);
    expect(restored.withMetadata, false);
    expect(restored.ignoreExtension, true);
  });

  test('RuleIncrement serialization', () {
    final rule = RuleIncrement('P', 1, 1, false, true);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleIncrement;
    
    expect(restored.prefix, 'P');
    expect(restored.startIndex, 1);
    expect(restored.step, 1);
    expect(restored.omitDash, false);
    expect(restored.ignoreExtension, true);
  });

  test('RuleRearrange serialization', () {
    final rule = RuleRearrange('-', [1, 3, 2], true);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleRearrange;
    
    expect(restored.delimiter, '-');
    expect(restored.order, [1, 3, 2]);
    expect(restored.ignoreExtension, true);
  });

  test('RuleTransliterate serialization', () {
    final rule = RuleTransliterate(Transliterate.pinyin);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleTransliterate;
    
    expect(restored.type, Transliterate.pinyin);
  });

  test('RuleTruncate serialization', () {
    final rule = RuleTruncate(1, 5, true, false, true, false);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleTruncate;
    
    expect(restored.index1, 1);
    expect(restored.index2, 5);
    expect(restored.i1toEnd, true);
    expect(restored.i2toEnd, false);
    expect(restored.ignoreExtension, true);
    expect(restored.keepBetween, false);
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/entity/transliterate.dart';
import 'package:flut_renamer/tools/rule_persistence.dart';

void main() {
  test('RuleReplace serialization', () {
    final rule = RuleReplace(
      'target',
      'replacement',
      1,
      false,
      true,
      false,
      true,
      dateFormat: 'dd/MM/yyyy',
    );
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleReplace;

    expect(restored.targetString, 'target');
    expect(restored.replacementString, 'replacement');
    expect(restored.replaceLimit, 1);
    expect(restored.withMetadata, false);
    expect(restored.caseSensitive, true);
    expect(restored.isRegex, false);
    expect(restored.ignoreExtension, true);
    expect(restored.dateFormat, 'dd/MM/yyyy');
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
    final rule = RuleInsert(
      'prefix',
      5,
      true,
      false,
      true,
      dateFormat: 'yyyyMMdd',
    );
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleInsert;

    expect(restored.insert, 'prefix');
    expect(restored.insertIndex, 5);
    expect(restored.toEnd, true);
    expect(restored.withMetadata, false);
    expect(restored.ignoreExtension, true);
    expect(restored.dateFormat, 'yyyyMMdd');
  });

  test('date format is persisted in YAML', () async {
    final directory =
        await Directory.systemTemp.createTemp('renamer_rules_date_format_');
    addTearDown(() => directory.delete(recursive: true));
    final yamlFile = File('${directory.path}/rules.yaml');

    await RulePersistence.saveRules(
      [
        RuleInsert(
          '{File:ModifyDate}',
          0,
          false,
          true,
          true,
          dateFormat: 'yyyy.MM.dd',
        ),
      ],
      targetFile: yamlFile,
    );

    expect(
      await yamlFile.readAsString(),
      contains('dateFormat: "yyyy.MM.dd"'),
    );
    final restored = await RulePersistence.loadRules(sourceFile: yamlFile);
    expect((restored.single as RuleInsert).dateFormat, 'yyyy.MM.dd');
  });

  test('RuleIncrement serialization', () {
    final rule = RuleIncrement('P', 1, 1, false, true, minimumDigits: 4);
    final map = rule.toMap();
    final restored = RuleFactory.fromMap(map) as RuleIncrement;

    expect(restored.prefix, 'P');
    expect(restored.startIndex, 1);
    expect(restored.step, 1);
    expect(restored.omitDash, false);
    expect(restored.ignoreExtension, true);
    expect(restored.minimumDigits, 4);
  });

  test('RuleIncrement accepts persisted rules without a minimum digit count',
      () {
    final restored = RuleFactory.fromMap({
      'type': 'Increment',
      'prefix': 'P',
      'startIndex': 1,
      'step': 1,
      'omitDash': false,
      'ignoreExtension': true,
    }) as RuleIncrement;

    expect(restored.minimumDigits, 0);
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

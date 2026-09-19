import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:flut_renamer/tools/rule_persistence.dart';

void main() {
  test('saving rules creates a missing cache parent and preserves round trip',
      () async {
    final root = await Directory.systemTemp.createTemp('rules_missing_parent_');
    addTearDown(() => root.delete(recursive: true));
    final target = File('${root.path}/missing/cache/temp_rules.yaml');
    expect(await target.parent.exists(), isFalse);
    final rule = RuleInsert('prefix-', 0, false, false, true);
    await RulePersistence.saveRules([rule], targetFile: target);
    final restored = await RulePersistence.loadRules(sourceFile: target);
    expect(restored.single.toMap(), rule.toMap());
    await RulePersistence.saveRules([], targetFile: target);
    expect(await RulePersistence.loadRules(sourceFile: target), isEmpty);
  });
}

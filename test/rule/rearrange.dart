library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  test('basic rearrange', () async {
    String fileName = "China-Hubei-Wuhan-Gangbusters-20220820.ARW";
    String delimiter = "-";
    List<int> order = [4, 3, 2, 1, 5];
    bool ignoreExtension = true;

    String newFileName = RuleRearrange(
      delimiter,
      order,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "Gangbusters-Wuhan-Hubei-China-20220820.ARW");
  });

  test('ignores invalid positions and permits duplicate positions', () {
    final rule = RuleRearrange('-', [3, 0, 2, 9, 2], true);

    expect(rule.newName('one-two-three.txt'), 'three-two-two.txt');
  });

  test('keeps the extension when it participates in rearrangement', () {
    final rule = RuleRearrange('-', [2, 1], false);

    expect(rule.newName('front-back.txt'), 'back.txt-front');
  });
}

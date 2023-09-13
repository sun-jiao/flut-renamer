library renamer.test.rule.rearrange;

import 'package:flutter_test/flutter_test.dart';
import 'package:renamer/entity/rule.dart';

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
}

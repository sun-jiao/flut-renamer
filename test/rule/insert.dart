library renamer.test.rule.insert;

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  test('basic insert', () async {
    String fileName = "SJ628901.ARW";
    String insert = 'Bambusicola thoracicus-'; // string to be inserted
    int index = 0; // insert before character at index
    bool toEnd = false; // true: count from end; false: from start.
    bool ignoreExtension = true;

    String newFileName = await RuleInsert(
      insert,
      index,
      toEnd,
      false,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "Bambusicola thoracicus-SJ628901.ARW");
  });

  test('insert from end', () async {
    String fileName = "SJ628901.ARW";
    String insert = '-Bambusicola thoracicus'; // string to be inserted
    int index = 0; // insert before character at index
    bool toEnd = true; // true: count from end; false: from start.
    bool ignoreExtension = true;

    String newFileName = await RuleInsert(
      insert,
      index,
      toEnd,
      false,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "SJ628901-Bambusicola thoracicus.ARW");
  });

  test('insert from end with fixed index', () async {
    String fileName = "SJ628901.ARW";
    String insert = '-Bamtho'; // string to be inserted
    int index = 4; // insert before character at index
    bool toEnd = true; // true: count from end; false: from start.
    bool ignoreExtension = true;

    final rule = RuleInsert(
      insert,
      index,
      toEnd,
      false,
      ignoreExtension,
    );

    String newFileName = await rule.newName(fileName);

    expect(newFileName, "SJ62-Bamtho8901.ARW");

    newFileName = await rule.newName(newFileName);

    expect(newFileName, "SJ62-Bamtho-Bamtho8901.ARW");

    newFileName = await rule.newName(newFileName);

    expect(newFileName, "SJ62-Bamtho-Bamtho-Bamtho8901.ARW");
  });
}

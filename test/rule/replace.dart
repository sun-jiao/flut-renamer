library renamer.test.rule.replace;

import 'package:flutter_test/flutter_test.dart';
import 'package:renamer/entity/rule.dart';

void main() {
  test('basic replace', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 0;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "data_example_data_name_data.file");
  });

  test('replace, do not ignore extension', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 0;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = false;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "data_example_data_name_data.data");
  });

  test('replace, case sensitive', () async {
    String fileName = "File_example_file_name_FILE.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 0;
    bool caseSensitive = true;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "File_example_data_name_FILE.file");
  });

  test('replace, case insensitive', () async {
    String fileName = "File_example_file_name_FILE.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 0;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "data_example_data_name_data.file");
  });

  test('replace first', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 1;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "data_example_file_name_file.file");
  });

  test('replace last', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = -2;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "file_example_data_name_data.file");
  });

  test('replace with only target is regex', () async {
    String fileName = "example_file_name.txt";
    String targetString = r"(.*)_file";
    String replacementString = "new_file_name";
    int replaceCount = 1;
    bool caseSensitive = false;
    bool isRegex = true;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "new_file_name_name.txt");
  });

  test('replace with both target and replacement are regex', () async {
    String fileName = "example_file_name.txt";
    String targetString = r"(.*)_file_(.*)";
    String replacementString = r"\1_data_\2";
    int replaceCount = 1;
    bool caseSensitive = false;
    bool isRegex = true;
    bool ignoreExtension = true;

    String newFileName = RuleReplace(
        targetString,
        replacementString,
        replaceCount,
        caseSensitive,
        isRegex,
        ignoreExtension
    ).newName(fileName);

    expect(newFileName, "example_data_name.txt");
  });
}
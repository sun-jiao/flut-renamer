library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  test('basic replace', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 0;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
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

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
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

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
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

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "data_example_data_name_data.file");
  });

  test('replace, reserve capitalisation of unreplaced chars', () async {
    String fileName = "File_ExamPle_file_NaMe_FILE.File";
    String targetString = "file";
    String replacementString = "Data";
    int replaceCount = 0;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "Data_ExamPle_Data_NaMe_Data.File");
  });

  test('replace first', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = 1;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "data_example_file_name_file.file");
  });

  test('limited replacement uses matches from the original name', () async {
    final newFileName = await RuleReplace(
      'a',
      'ab',
      2,
      false,
      true,
      false,
      true,
    ).newName('a_a_a.txt');

    expect(newFileName, 'ab_ab_a.txt');
  });

  test('replace last', () async {
    String fileName = "file_example_file_name_file.file";
    String targetString = "file";
    String replacementString = "data";
    int replaceCount = -2;
    bool caseSensitive = false;
    bool isRegex = false;
    bool ignoreExtension = true;

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "file_example_data_name_data.file");
  });

  test('replace with only target is regex', () async {
    String fileName = "example_file_name.txt";
    String targetString = "(.*)_file";
    String replacementString = "new_file_name";
    int replaceCount = 1;
    bool caseSensitive = false;
    bool isRegex = true;
    bool ignoreExtension = true;

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "new_file_name_name.txt");
  });

  test('replace with both target and replacement are regex', () async {
    String fileName = "example_file_name.txt";
    String targetString = "(.*)_file_(.*)";
    String replacementString = r"\1_data_\2";
    int replaceCount = 1;
    bool caseSensitive = false;
    bool isRegex = true;
    bool ignoreExtension = true;

    String newFileName = await RuleReplace(
      targetString,
      replacementString,
      replaceCount,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    ).newName(fileName);

    expect(newFileName, "example_data_name.txt");
  });

  test('regex replacement preserves two-digit capture references', () async {
    final newFileName = await RuleReplace(
      '(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)',
      r'\10-\1',
      1,
      false,
      false,
      true,
      true,
    ).newName('abcdefghij.txt');

    expect(newFileName, 'j-a.txt');
  });

  test('does not parse metadata tags when metadata is disabled', () async {
    final newFileName = await RuleReplace(
      'file',
      '{File:Size}',
      0,
      false,
      false,
      false,
      true,
    ).newName('file.txt');

    expect(newFileName, '{File:Size}.txt');
  });

  test('replace with a random string', () async {
    final newFileName = await RuleReplace(
      'file',
      '{RandomString}',
      0,
      false,
      false,
      false,
      true,
    ).newName('file.txt');

    expect(newFileName, matches(RegExp(r'^[a-f0-9]{8}\.txt$')));
  });

  test('replace with a custom-length random string', () async {
    final newFileName = await RuleReplace(
      'file',
      '{RandomString:12}',
      0,
      false,
      false,
      false,
      true,
    ).newName('file.txt');

    expect(newFileName, matches(RegExp(r'^[a-f0-9]{12}\.txt$')));
  });
}

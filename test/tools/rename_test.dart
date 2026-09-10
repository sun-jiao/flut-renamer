import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/rename.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp('renamer_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async {
        if (call.method == 'getApplicationDocumentsDirectory') {
          return temporaryDirectory.path;
        }
        return null;
      },
    );
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    await temporaryDirectory.delete(recursive: true);
  });

  test('replaces every filesystem-reserved character in a file name', () {
    expect(
      replaceSpecialCharacters(r'a\b/c:d*e?f"g<h>i|j'),
      'a⧵b∕c∶d＊e﹖f\'\'g〈h〉iǀj',
    );
  });

  test('renames a local file and returns its new entity', () async {
    final source = File('${temporaryDirectory.path}/before.txt');
    await source.writeAsString('contents');
    final file = FileEntity(source, newName: 'after.txt');

    final renamed = await rename(file);

    expect(renamed, isNotNull);
    expect(renamed!.path, '${temporaryDirectory.path}/after.txt');
    expect(await File(renamed.path).readAsString(), 'contents');
    expect(await source.exists(), isFalse);
  });

  test('does not rename a file when its name is unchanged', () async {
    final source = File('${temporaryDirectory.path}/unchanged.txt');
    await source.writeAsString('contents');
    final file = FileEntity(source);

    final renamed = await rename(file);

    expect(identical(renamed, file), isTrue);
    expect(await source.exists(), isTrue);
  });

  test('sanitizes a new name before renaming the file', () async {
    final source = File('${temporaryDirectory.path}/source.txt');
    await source.writeAsString('source');
    final file = FileEntity(source, newName: 'destination:name.txt');

    final renamed = await rename(file);

    expect(renamed, isNotNull);
    expect(file.newName, 'destination∶name.txt');
    expect(
      await File('${temporaryDirectory.path}/destination∶name.txt')
          .readAsString(),
      'source',
    );
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/file_metadata.dart';

void main() {
  test('formats file dates with the selected date format', () async {
    final directory =
        await Directory.systemTemp.createTemp('renamer_metadata_');
    addTearDown(() => directory.delete(recursive: true));

    final file = File('${directory.path}/sample.txt');
    await file.writeAsString('metadata');
    final metadata = FileMetadata(file);
    await metadata.init();

    expect(
      metadata.getByName('File:ModifyDate', dateFormat: 'yyyyMMdd'),
      matches(r'^\d{8}$'),
    );
    expect(
      metadata.getByName('File:ModifyDate', dateFormat: 'yyyy_MM_dd'),
      matches(r'^\d{4}_\d{2}_\d{2}$'),
    );
    expect(
      metadata.getByName('File:ModifyTime', dateFormat: 'yyyyMMdd'),
      matches(r'^\d{8} \d{2}-\d{2}-\d{2}$'),
    );
    expect(
      metadata.parse('{File:ModifyDate}', dateFormat: 'yyyyMMdd'),
      matches(r'^\d{8}$'),
    );
    expect(
      metadata.getByName('File:ModifyDate', dateFormat: 'not-a-format'),
      matches(r'^\d{4}-\d{2}-\d{2}$'),
    );
  });
}

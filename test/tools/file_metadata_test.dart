import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/tools/file_metadata.dart';

void main() {
  test('formats audio duration using component units', () {
    expect(
      FileMetadata.formatDuration(
        const Duration(
          hours: 1,
          minutes: 2,
          seconds: 3,
          milliseconds: 450,
        ),
      ),
      '1:02:03.45',
    );
  });

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

  test('preserves the time in EXIF photo timestamps', () async {
    final directory =
        await Directory.systemTemp.createTemp('renamer_metadata_');
    addTearDown(() => directory.delete(recursive: true));

    final file = File('${directory.path}/photo.jpg');
    await file.writeAsBytes(_jpegWithExifTimestamp);
    final metadata = FileMetadata(file);
    await metadata.init();

    expect(
      metadata.getByName('Photo:Time'),
      '2024-05-06 12-34-56',
    );
  });

  test('shares in-flight metadata initialization per file', () async {
    final directory =
        await Directory.systemTemp.createTemp('renamer_metadata_');
    addTearDown(() => directory.delete(recursive: true));

    final file = File('${directory.path}/sample.txt');
    await file.writeAsString('metadata');
    final entity = FileEntity(file);

    final first = entity.initMetadata();
    final second = entity.initMetadata();

    await Future.wait([first, second]);
    expect(entity.metadata!.inited, isTrue);
  });
}

const _jpegWithExifTimestamp = <int>[
  0xff, 0xd8, // SOI
  0xff, 0xe1, 0x00, 0x48, // APP1 (Exif)
  0x45, 0x78, 0x69, 0x66, 0x00, 0x00, // Exif header
  0x4d, 0x4d, 0x00, 0x2a, 0x00, 0x00, 0x00, 0x08, // TIFF header
  0x00, 0x01, // IFD0 entry count
  0x87, 0x69, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x1a,
  0x00, 0x00, 0x00, 0x00, // next IFD offset
  0x00, 0x01, // EXIF IFD entry count
  0x90, 0x03, 0x00, 0x02, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x2c,
  0x00, 0x00, 0x00, 0x00, // next IFD offset
  0x32, 0x30, 0x32, 0x34, 0x3a, 0x30, 0x35, 0x3a, 0x30, 0x36,
  0x20, 0x31, 0x32, 0x3a, 0x33, 0x34, 0x3a, 0x35, 0x36, 0x00,
  0xff, 0xd9, // EOI
];

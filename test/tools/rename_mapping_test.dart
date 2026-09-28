import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/rename_mapping.dart';
import 'package:path/path.dart' as p;

void main() {
  final source = p.absolute('照片,一.jpg');
  Matcher error(MappingError reason, int row) => isA<MappingException>()
      .having((e) => e.reason, 'reason', reason)
      .having((e) => e.row, 'row', row);

  test('CSV roundtrip handles Unicode, commas, escaped quotes and BOM', () {
    final quoted = p.absolute('a"b.txt');
    final csv =
        RenameMapping.encode([(source, '旅行,001.jpg'), (quoted, 'b.txt')]);
    expect(RenameMapping.parse('\ufeff$csv', [source, quoted]), {
      source: '旅行,001.jpg',
      quoted: 'b.txt',
    });
  });

  test('TSV handles CRLF and blank rows', () {
    expect(
      RenameMapping.parse(
        '\ufeffsource\tnew_name\r\n\r\n$source\t新名称.jpg\r\n',
        [source],
        delimiter: '\t',
      ),
      {source: '新名称.jpg'},
    );
  });

  test('normalizes absolute paths and keeps content URIs opaque', () {
    final normalized = p.normalize(p.absolute('folder', '..', 'file.txt'));
    const uri = 'content://provider/document/a%2Fb';
    expect(
      RenameMapping.parse(
        RenameMapping.encode([
          (p.join(p.dirname(normalized), '.', 'file.txt'), 'a.txt'),
          (uri, 'b.txt'),
        ]),
        [normalized, uri],
      ),
      {normalized: 'a.txt', uri: 'b.txt'},
    );
  });

  test('rejects unlisted and relative sources instead of guessing basenames',
      () {
    for (final path in ['photo.jpg', p.absolute('missing.jpg')]) {
      expect(
        () => RenameMapping.parse(
          RenameMapping.encode([(path, 'new.jpg')]),
          [source],
        ),
        throwsA(error(MappingError.source, 2)),
      );
    }
  });

  test('rejects a duplicate source even when targets agree', () {
    expect(
      () => RenameMapping.parse(
        RenameMapping.encode([(source, 'new.jpg'), (source, 'new.jpg')]),
        [source],
      ),
      throwsA(error(MappingError.duplicate, 3)),
    );
  });

  test('reports physical row after a quoted multiline source', () {
    final multiline = p.absolute('a\nb.txt');
    expect(
      () => RenameMapping.parse(
        RenameMapping.encode(
          [(multiline, 'ok.txt'), (multiline, 'other.txt')],
        ),
        [multiline],
      ),
      throwsA(error(MappingError.duplicate, 4)),
    );
  });

  test('rejects malformed headers, fields, quotes and empty tables', () {
    for (final text in [
      '',
      'source,new_name\n',
      'old,new\na,b',
      'source,new_name\n"unterminated',
      'source,new_name\n"a"x,b',
      'source,new_name\na"b,c',
      'source,new_name\na,b,c',
    ]) {
      expect(
        () => RenameMapping.parse(text, [source]),
        throwsA(isA<MappingException>()),
      );
    }
  });

  test(
      'rejects invalid and nonportable target names without silently sanitizing',
      () {
    for (final name in [
      '',
      ' ',
      '.',
      '..',
      '../a',
      'a/b',
      r'a\b',
      'a\n.txt',
      'a\u0000.txt',
      'a?.txt',
      'a:',
      'a".txt',
      'CON',
      'nul.txt',
      'LPT1.txt',
      'a.',
      'a ',
    ]) {
      expect(
        () => RenameMapping.parse(
          RenameMapping.encode([(source, name)]),
          [source],
        ),
        throwsA(error(MappingError.name, 2)),
        reason: name,
      );
    }
  });

  test('rejects oversized input', () {
    expect(
      () => RenameMapping.parse('x' * (RenameMapping.maxBytes + 1), []),
      throwsA(error(MappingError.tooLarge, 1)),
    );
  });
}

import 'package:path/path.dart' as p;

/// CSV/TSV mappings only address already-authorized, loaded sources.
enum MappingError { format, source, duplicate, name, tooLarge }

class MappingException implements Exception {
  const MappingException(this.row, this.reason);
  final int row;
  final MappingError reason;
}

class RenameMapping {
  static const maxBytes = 5 * 1024 * 1024;

  static String sourceKey(String source) => source.startsWith('content://')
      ? source
      : p.normalize(p.absolute(source));

  static Map<String, String> parse(
    String text,
    Iterable<String> loadedSources, {
    String delimiter = ',',
  }) {
    if (text.length > maxBytes) {
      throw const MappingException(1, MappingError.tooLarge);
    }
    if (delimiter != ',' && delimiter != '\t') {
      throw ArgumentError.value(delimiter, 'delimiter');
    }
    final rows = _rows(text, delimiter);
    if (rows.isEmpty ||
        rows.first.$2.length != 2 ||
        rows.first.$2[0].trim() != 'source' ||
        rows.first.$2[1].trim() != 'new_name') {
      throw const MappingException(1, MappingError.format);
    }
    final available = <String, String>{};
    for (final source in loadedSources) {
      final key = sourceKey(source);
      if (available.containsKey(key)) {
        throw const MappingException(1, MappingError.duplicate);
      }
      available[key] = source;
    }
    final result = <String, String>{};
    for (final (row, cells) in rows.skip(1)) {
      if (cells.length != 2) throw MappingException(row, MappingError.format);
      final source = cells[0];
      if ((!p.isAbsolute(source) && !source.startsWith('content://')) ||
          !available.containsKey(sourceKey(source))) {
        throw MappingException(row, MappingError.source);
      }
      final original = available[sourceKey(source)]!;
      if (result.containsKey(original)) {
        throw MappingException(row, MappingError.duplicate);
      }
      final name = cells[1];
      if (name.trim().isEmpty ||
          name == '.' ||
          name == '..' ||
          name.endsWith('.') ||
          name.endsWith(' ') ||
          RegExp(r'[\x00-\x1f\x7f\\/:*?"<>|]').hasMatch(name) ||
          RegExp(
            r'^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)',
            caseSensitive: false,
          ).hasMatch(name)) {
        throw MappingException(row, MappingError.name);
      }
      result[original] = name;
    }
    if (result.isEmpty) throw const MappingException(2, MappingError.format);
    return result;
  }

  /// UTF-8 encoding and a BOM are supplied by the export caller.
  static String encode(Iterable<(String, String)> entries) {
    String quote(String cell) => '"${cell.replaceAll('"', '""')}"';
    return 'source,new_name\r\n${entries.map((row) => '${quote(row.$1)},${quote(row.$2)}\r\n').join()}';
  }

  /// Strict quoted fields, escaped quotes, CRLF/LF, BOM and physical line numbers.
  static List<(int, List<String>)> _rows(String input, String delimiter) {
    final text = input.startsWith('\ufeff') ? input.substring(1) : input;
    final rows = <(int, List<String>)>[];
    var fields = <String>[];
    var field = StringBuffer();
    var quoted = false;
    var closed = false;
    var started = false;
    var line = 1;
    var rowLine = 1;
    void endField() {
      fields.add(field.toString());
      field = StringBuffer();
      closed = false;
      started = false;
    }

    void endRow() {
      endField();
      if (fields.length != 1 || fields.single.isNotEmpty) {
        rows.add((rowLine, fields));
      }
      fields = [];
    }

    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (quoted) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            quoted = false;
            closed = true;
          }
        } else {
          field.write(c);
          if (c == '\n' ||
              (c == '\r' && (i + 1 == text.length || text[i + 1] != '\n'))) {
            line++;
          }
        }
      } else if (c == delimiter) {
        endField();
      } else if (c == '\r' || c == '\n') {
        endRow();
        if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        line++;
        rowLine = line;
      } else if (c == '"' && !started && !closed) {
        quoted = true;
        started = true;
      } else {
        if (closed || c == '"') {
          throw MappingException(rowLine, MappingError.format);
        }
        field.write(c);
        started = true;
      }
    }
    if (quoted) throw MappingException(rowLine, MappingError.format);
    if (started || closed || fields.isNotEmpty) endRow();
    return rows;
  }
}

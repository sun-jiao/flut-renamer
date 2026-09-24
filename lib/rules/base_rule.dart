part of 'rule.dart';

abstract interface class Rule {
  FutureOr<String> newName(String oldName, {FileMetadata? metadata});

  /// Whether evaluating this rule needs file, EXIF, or audio metadata.
  ///
  /// Rules that merely have metadata mode enabled but contain no metadata tag
  /// do not need to cause an expensive metadata read.
  bool get requiresMetadata;

  void openDialog(BuildContext context, Function(Rule rule) onSave);

  Map<String, dynamic> toMap();

  @override
  String toString();
}

(String, String) splitFileName(String oldName, bool ignoreExtension) {
  String newName = oldName;
  String extension = '';

  if (ignoreExtension) {
    final lastIndex = oldName.lastIndexOf('.');

    if (lastIndex > 0) {
      extension = oldName.substring(lastIndex);
      newName = oldName.substring(0, lastIndex);
    }
  }

  return (newName, extension);
}

/// Positions are extended grapheme clusters (user-visible characters).
int _characterPosition(int length, int index, bool fromEnd) =>
    (fromEnd ? length - index : index).clamp(0, length);

String _insertCharacters(String name, String text, int index, bool fromEnd) {
  final characters = name.characters.toList();
  final position = _characterPosition(characters.length, index, fromEnd);
  return characters.take(position).join() +
      text +
      characters.skip(position).join();
}

/// RegExp offsets are UTF-16 offsets. Only accept whole-character ranges,
/// including zero-width matches at character boundaries.
Iterable<Match> _wholeCharacterMatches(String name, Pattern pattern) sync* {
  final boundaries = <int>{0};
  var offset = 0;
  for (final character in name.characters) {
    offset += character.length;
    boundaries.add(offset);
  }
  for (final match in pattern.allMatches(name)) {
    if (boundaries.contains(match.start) && boundaries.contains(match.end)) {
      yield match;
    }
  }
}

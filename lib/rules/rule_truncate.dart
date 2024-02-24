part of 'rule.dart';

class RuleTruncate implements Rule {
  RuleTruncate(
    this.startIndex,
    this.fromStart,
    this.direction,
    this.length,
    this.ignoreExtension,
    this.keep,
  );

  final int startIndex; // count from
  final bool fromStart; // true: count from start, false: count from end.
  final bool direction; // truncate direction
  final int length; // truncate length
  final bool ignoreExtension;
  final bool keep; // true: keep chars in ranges, false: keep out of range

  @override
  String newName(String oldName, {FileMetadata? metadata}) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    int index = startIndex;

    if (!fromStart) {
      index = newName.length - index + 1;
    }

    int start;
    int end;

    if (direction) {
      start = index - 1;
      end = index + length - 1;
    } else {
      start = index - length;
      end = index;
    }

    if (start < 0) {
      start = 0;
    } else if (start >= newName.length) {
      start = newName.length;
    }

    if (end < 0) {
      end = 0;
    } else if (end >= newName.length) {
      end = newName.length;
    }

    if (keep) {
      newName = newName.substring(start, end);
    } else {
      newName = newName.replaceRange(start, end, '');
    }

    return newName + extension;
  }

  @override
  String toString() {
    return L10n.current.truncateToString(
      keep ? 1 : 0,
      fromStart ? 1 : 0,
      direction ? 1 : 0,
      length,
      startIndex,
    );
  }
}

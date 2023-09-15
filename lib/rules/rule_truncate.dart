part of 'rule.dart';

class RuleTruncate implements Rule {
  RuleTruncate(
    this.startIndex,
    this.fromStart,
    this.direction,
    this.length,
    this.ignoreExtension,
  );

  final int startIndex; // count from
  final bool fromStart; // true: count from start, false: count from end.
  final bool direction; // truncate direction
  final int length; // truncate length
  final bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    int index = startIndex;

    if (fromStart) {
      index = newName.length + index;
    }

    if (index < 0) {
      index = 0;
    } else if (index >= newName.length) {
      index = newName.length;
    }

    if (direction) {
      newName = newName.substring(index, index + length);
    } else {
      newName = newName.substring(index - length + 1, index + 1);
    }

    return newName + extension;
  }

  @override
  String toString() {
    return 'Truncate.';
  }
}

part of 'rule.dart';

class RuleTruncate implements Rule {
  RuleTruncate(
    this.index1,
    this.index2,
    this.i1toEnd,
    this.i2toEnd,
    this.ignoreExtension,
    this.keepBetween,
  );

  final int index1;
  final int index2;
  final bool i1toEnd;
  final bool i2toEnd;
  final bool ignoreExtension;
  final bool keepBetween; // true: keep chars between 2 indexes, false: keep chars around them

  @override
  String newName(String oldName, {FileMetadata? metadata}) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    int start = index1;

    if (i1toEnd) {
      start = newName.length + start;
    }

    int end = index2;

    if (i2toEnd) {
      end = newName.length + end;
    }

    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }

    if (keepBetween) {
      newName = newName.substring(start, end);
    } else {
      newName = newName.replaceRange(start, end, '');
    }

    return newName + extension;
  }

  @override
  String toString() {
    return L10n.current.truncateToString(
      keepBetween ? 0 : 1,
      i1toEnd ? 0 : 1,
      i2toEnd ? 0 : 1,
      index1,
      index2,
    );
  }
}

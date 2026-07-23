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
      i2toEnd.toString(),
      'o${index1 % 10}',
      i1toEnd.toString(),
      'o${index2 % 10}',
      keepBetween.toString(),
      index1,
      index2,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'Truncate',
      'index1': index1,
      'index2': index2,
      'i1toEnd': i1toEnd,
      'i2toEnd': i2toEnd,
      'ignoreExtension': ignoreExtension,
      'keepBetween': keepBetween,
    };
  }

  factory RuleTruncate.fromMap(Map<dynamic, dynamic> map) {
    return RuleTruncate(
      map['index1'] as int,
      map['index2'] as int,
      map['i1toEnd'] as bool,
      map['i2toEnd'] as bool,
      map['ignoreExtension'] as bool,
      map['keepBetween'] as bool,
    );
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) => showTruncateDialog(context, onSave, this);
}

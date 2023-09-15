part of 'rule.dart';

class RuleInsert implements Rule {
  RuleInsert(
    this.insert,
    this.insertIndex,
    this.fromStart,
    this.ignoreExtension,
  );

  final String insert; // string to be inserted
  final int insertIndex; // insert before character at index
  final bool fromStart; // true: count from start; false: from end.
  final bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    int index = insertIndex;

    if (!fromStart) {
      index = newName.length - index;
    }

    if (index < 0) {
      index = 0;
    } else if (index > newName.length) {
      index = newName.length;
    }

    newName = newName.substring(0, index) + insert + newName.substring(index);

    return newName + extension;
  }

  @override
  String toString() {
    return 'Insert "$insert" at char #$insertIndex from ${fromStart ? 'start' : 'end'}';
  }
}

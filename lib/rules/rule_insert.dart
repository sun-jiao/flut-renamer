part of 'rule.dart';

class RuleInsert implements Rule {
  RuleInsert(
    this.insert,
    this.insertIndex,
    this.fromStart,
    this.withMetadata,
    this.ignoreExtension,
  );

  final String insert; // string to be inserted
  final int insertIndex; // insert before character at index
  final bool fromStart; // true: count from start; false: from end.
  final bool withMetadata; // true: replace metadata tag with metadata
  final bool ignoreExtension;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) async {
    if (withMetadata && metadata == null) {
      throw ArgumentError('Contains metadata tag while MetadataParser was not provided.');
    }

    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    String insert = this.insert;

    if (withMetadata) {
      await metadata!.init();
      insert = metadata.parse(insert);
    }

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

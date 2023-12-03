part of 'rule.dart';

class RuleIncrement implements Rule {
  RuleIncrement(
    this.prefix,
    this.startIndex,
    this.step,
    this.omitDash,
    this.ignoreExtension,
  ) : index = startIndex;

  int index;

  final String prefix;
  final int startIndex; // start index, first file will be renamed as "prefix-startIndex"
  final int step; // incremental step of index
  final bool omitDash; // omit the dash between prefix and index
  final bool ignoreExtension;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) async {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    newName = prefix;

    if (!omitDash) {
      newName += '-';
    }

    newName += index.toString();
    index += step;

    return newName + extension;
  }

  @override
  String toString() {
    return 'Incremental renaming: $prefix-index';
  }

  void indexReset() {
    index = startIndex;
  }
}

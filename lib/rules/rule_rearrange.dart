part of 'rule.dart';

class RuleRearrange implements Rule {
  RuleRearrange(
    this.delimiter,
    this.order,
    this.ignoreExtension,
  );

  final String delimiter; // split delimiter
  final List<int> order; // true: count from start; false: from end.
  final bool ignoreExtension;

  @override
  String newName(String oldName, {MetadataParser? parser}) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    // split string
    List<String> substrings = newName.split(delimiter);

    // remove indexes out of limit
    final order = this
        .order
        .where((index) => index >= 1 && index <= substrings.length)
        .toList();

    // rearrange substrings
    List<String> reorderedSubstrings =
        order.map((index) => substrings[index - 1]).toList();

    // join substrings
    String result = reorderedSubstrings.join(delimiter);

    return result + extension;
  }

  @override
  String toString() {
    return 'Rearrange: delimiter: "$delimiter", order: "$order".';
  }
}

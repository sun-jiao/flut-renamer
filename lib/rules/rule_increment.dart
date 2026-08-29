part of 'rule.dart';

class RuleIncrement implements Rule {
  RuleIncrement(this.prefix, this.startIndex, this.step, this.omitDash,
      this.ignoreExtension,
      {this.minimumDigits = 0})
      : index = startIndex;

  int index;

  final String prefix;
  final int
      startIndex; // start index, first file will be renamed as "prefix-startIndex"
  final int step; // incremental step of index
  final bool omitDash; // omit the dash between prefix and index
  final bool ignoreExtension;
  final int minimumDigits;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) async {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    newName = prefix;

    if (!omitDash) {
      newName += '-';
    }

    newName += index.toString().padLeft(minimumDigits, '0');
    index += step;

    return newName + extension;
  }

  @override
  String toString() {
    return L10n.current.incrementToString(prefix);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'Increment',
      'prefix': prefix,
      'startIndex': startIndex,
      'step': step,
      'omitDash': omitDash,
      'ignoreExtension': ignoreExtension,
      'minimumDigits': minimumDigits,
    };
  }

  factory RuleIncrement.fromMap(Map<dynamic, dynamic> map) {
    return RuleIncrement(
      map['prefix'] as String,
      map['startIndex'] as int,
      map['step'] as int,
      map['omitDash'] as bool,
      map['ignoreExtension'] as bool,
      minimumDigits: map['minimumDigits'] as int? ?? 0,
    );
  }

  void indexReset() {
    index = startIndex;
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) =>
      showIncrementDialog(context, onSave, this);
}

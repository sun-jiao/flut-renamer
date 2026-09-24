part of 'rule.dart';

enum IncrementMode { replace, insert }

class RuleIncrement implements Rule {
  RuleIncrement(
    this.prefix,
    this.startIndex,
    this.step,
    this.omitDash,
    this.ignoreExtension, {
    this.minimumDigits = 0,
    this.mode = IncrementMode.replace,
    this.insertIndex = 0,
    this.toEnd = false,
    this.suffix = '',
  }) : index = startIndex;

  int index;

  final String prefix;
  final int
      startIndex; // start index, first file will be renamed as "prefix-startIndex"
  final int step; // incremental step of index
  final bool omitDash; // omit the dash between prefix and index
  final bool ignoreExtension;
  final int minimumDigits;
  final IncrementMode mode;
  final int insertIndex;
  final bool toEnd;
  final String suffix;

  @override
  bool get requiresMetadata => false;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) async {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    final number = index.toString().padLeft(minimumDigits, '0');
    if (mode == IncrementMode.insert) {
      newName = _insertCharacters(
        newName,
        '$prefix$number$suffix',
        insertIndex,
        toEnd,
      );
    } else {
      newName = '$prefix${omitDash ? '' : '-'}$number$suffix';
    }
    index += step;

    return newName + extension;
  }

  @override
  String toString() {
    final number = startIndex.toString().padLeft(minimumDigits, '0');
    final text =
        '$prefix${mode == IncrementMode.replace && !omitDash ? '-' : ''}$number$suffix';
    if (mode == IncrementMode.insert) {
      return '${L10n.current.increment}: ${L10n.current.insertToString(toEnd.toString(), 'o${insertIndex % 10}', text, insertIndex)}';
    }
    return '${L10n.current.increment}: $text';
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
      'mode': mode.name,
      'insertIndex': insertIndex,
      'toEnd': toEnd,
      'suffix': suffix,
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
      mode: IncrementMode.values.byName(map['mode'] as String? ?? 'replace'),
      insertIndex: map['insertIndex'] as int? ?? 0,
      toEnd: map['toEnd'] as bool? ?? false,
      suffix: map['suffix'] as String? ?? '',
    );
  }

  void indexReset() {
    index = startIndex;
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) =>
      showIncrementDialog(context, onSave, this);
}

part of 'rule.dart';

class RuleRemove implements Rule {
  RuleRemove(
    this.targetString, // keyword to be searched and removed.
    int removeLimit, // 0: all matches; positive: from start; negative: from end.
    bool caseSensitive,
    bool isRegex,
    bool ignoreExtension,
  ) {
    ruleReplace = RuleReplace(
      targetString,
      '',
      removeLimit,
      false,
      caseSensitive,
      isRegex,
      ignoreExtension,
    );
  }

  final String targetString;
  late final RuleReplace ruleReplace;

  @override
  Future<String> newName(String fileName, {FileMetadata? metadata}) =>
      ruleReplace.newName(fileName, metadata: metadata);

  @override
  String toString() {
    return L10n.current.removeToString(targetString);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'Remove',
      'targetString': targetString,
      'removeLimit': ruleReplace.replaceLimit,
      'caseSensitive': ruleReplace.caseSensitive,
      'isRegex': ruleReplace.isRegex,
      'ignoreExtension': ruleReplace.ignoreExtension,
    };
  }

  factory RuleRemove.fromMap(Map<dynamic, dynamic> map) {
    return RuleRemove(
      map['targetString'] as String,
      map['removeLimit'] as int,
      map['caseSensitive'] as bool,
      map['isRegex'] as bool,
      map['ignoreExtension'] as bool,
    );
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) => showRemoveDialog(context, onSave, this);
}

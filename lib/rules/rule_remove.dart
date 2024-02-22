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
}

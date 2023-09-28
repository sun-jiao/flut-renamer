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
  Future<String> newName(String fileName, {MetadataParser? parser}) => ruleReplace.newName(fileName, parser: parser);

  @override
  String toString() {
    return 'Remove "$targetString"';
  }
}

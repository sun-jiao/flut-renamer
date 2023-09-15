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
        targetString, '', removeLimit, caseSensitive, isRegex, ignoreExtension);
  }

  final String targetString;
  late final RuleReplace ruleReplace;

  @override
  String newName(String fileName) => ruleReplace.newName(fileName);

  @override
  String toString() {
    return 'Remove "$targetString"';
  }
}

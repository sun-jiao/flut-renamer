part of 'rule.dart';

class RuleReplace implements Rule {
  RuleReplace(
    this.targetString,
    this.replacementString,
    this.replaceLimit,
    this.withMetadata,
    this.caseSensitive,
    this.isRegex,
    this.ignoreExtension,
  );

  final String targetString; // target to be matched and replaced.
  final String replacementString; // `targetString` will be replaced to this.
  // 0: all matches; positive: from start; negative: from end.
  final int replaceLimit;
  final bool withMetadata; // true: replace metadata tag with metadata
  final bool caseSensitive;
  final bool isRegex;
  final bool ignoreExtension;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) async {
    if (targetString.isEmpty) {
      return oldName;
    }

    if (withMetadata && metadata == null) {
      throw ArgumentError(L10n.current.metadataParserNotProvided);
    }

    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    String parsedReplacement = replacementString;

    // 检查并替换特殊的随机字符串标记，支持在任何位置出现
    if (parsedReplacement.contains('{RandomString}')) {
      parsedReplacement = parsedReplacement.replaceAll(
          '{RandomString}', Uuid().v4().substring(0, 8));
    }

    if (withMetadata) {
      await metadata!.init();
      parsedReplacement = metadata.parse(parsedReplacement);
    }

    Pattern target;
    String Function(Match) replacer;

    if (isRegex) {
      target = RegExp(targetString, caseSensitive: caseSensitive);
      replacer = (match) {
        List<String?> groups = match
            .groups(List<int>.generate(match.groupCount + 1, (index) => index));

        String replacedString = parsedReplacement;
        for (int i = 0; i <= match.groupCount; i++) {
          replacedString = replacedString.replaceAll('\\$i', groups[i] ?? '');
        }

        return replacedString;
      };
    } else {
      target =
          RegExp(RegExp.escape(targetString), caseSensitive: caseSensitive);
      replacer = (match) => parsedReplacement;
    }

    if (replaceLimit == 0) {
      newName = newName.replaceAllMapped(target, replacer);
    } else if (replaceLimit > 0) {
      for (int i = 0; i < replaceLimit; i++) {
        newName = newName.replaceFirstMapped(target, replacer);
      }
    } else {
      for (int i = 0; i > replaceLimit; i--) {
        newName = newName.replaceLastMapped(target, replacer);
      }
    }

    return newName + extension;
  }

  @override
  String toString() {
    return L10n.current.replaceToString(targetString, replacementString);
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) =>
      showReplaceDialog(context, onSave, this);
}

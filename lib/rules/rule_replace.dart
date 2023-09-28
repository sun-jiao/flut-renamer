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
  Future<String> newName(String oldName, {MetadataParser? parser}) async {
    if (withMetadata && parser == null) {
      throw ArgumentError('Contains metadata tag while MetadataParser was not provided.');
    }

    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    String replacementString = this.replacementString;

    if (withMetadata) {
      await parser!.init();
      replacementString = parser.parse(replacementString);
    }

    Pattern target;
    String Function(Match) replacer;

    if (isRegex) {
      target = RegExp(targetString, caseSensitive: caseSensitive);
      replacer = (match) {
        List<String?> groups = match
            .groups(List<int>.generate(match.groupCount + 1, (index) => index));

        String replacedString = replacementString;
        for (int i = 0; i <= match.groupCount; i++) {
          replacedString = replacedString.replaceAll('\\$i', groups[i] ?? '');
        }

        return replacedString;
      };
    } else {
      target =
          RegExp(RegExp.escape(targetString), caseSensitive: caseSensitive);
      replacer = (match) => replacementString;
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
    return 'Replace "$targetString" with "$replacementString".';
  }
}

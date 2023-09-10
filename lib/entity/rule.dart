import 'package:renamer/entity/string_x.dart';

abstract class Rule {
  String newName(String oldName);

  @override
  String toString();
}

class RuleReplace implements Rule {
  RuleReplace(
    this.targetString,
    this.replacementString,
    this.replaceCount,
    this.caseSensitive,
    this.isRegex,
    this.ignoreExtension,
  );

  String targetString; // target to be matched and replaced.
  String replacementString; // `targetString` will be replaced to this.
  int replaceCount; // 0: all matches; positive: from start; negative: from end.
  bool caseSensitive;
  bool isRegex;
  bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName = oldName;
    String extension = '';

    if (ignoreExtension) {
      final lastIndex = oldName.lastIndexOf('.');

      extension = oldName.substring(lastIndex);
      newName = oldName.substring(0, lastIndex);
    }

    if (!caseSensitive) {
      targetString = targetString.toLowerCase();
      newName = newName.toLowerCase();
    }

    Pattern target;
    String Function(Match) replacer;

    if (isRegex) {
      target = RegExp(targetString);
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
      target = targetString;
      replacer = (match) => replacementString;
    }

    if (replaceCount == 0) {
      newName = newName.replaceAllMapped(target, replacer);
    } else if (replaceCount > 0) {
      for (int i = 0; i < replaceCount; i++) {
        newName = newName.replaceFirstMapped(target, replacer);
      }
    } else {
      for (int i = 0; i > replaceCount; i--) {
        newName = newName.replaceLastMapped(target, replacer);
      }
    }

    return newName + extension;
  }

  @override
  String toString() {
    return 'Replace $targetString with $replacementString.';
  }
}

class RuleRemove implements Rule {
  RuleRemove(
      this.targetString, // keyword to be searched and removed.
      int removeCount, // 0: all matches; positive: from start; negative: from end.
      bool caseSensitive,
      bool isRegex,
      bool ignoreExtension) {
    ruleReplace = RuleReplace(targetString, '', removeCount,
        caseSensitive, isRegex, ignoreExtension);
  }

  String targetString;
  late final RuleReplace ruleReplace;

  @override
  String newName(String fileName) => ruleReplace.newName(fileName);

  @override
  String toString() {
    return 'Remove $targetString';
  }
}

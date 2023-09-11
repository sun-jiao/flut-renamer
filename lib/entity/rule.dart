import 'string_x.dart';

abstract class Rule {
  String newName(String oldName);

  @override
  String toString();
}

class RuleReplace implements Rule {
  RuleReplace(
    this.targetString,
    this.replacementString,
    this.replaceLimit,
    this.caseSensitive,
    this.isRegex,
    this.ignoreExtension,
  );

  final String targetString; // target to be matched and replaced.
  final String replacementString; // `targetString` will be replaced to this.
  final int replaceLimit; // 0: all matches; positive: from start; negative: from end.
  final bool caseSensitive;
  final bool isRegex;
  final bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName = oldName;
    String extension = '';

    if (ignoreExtension) {
      final lastIndex = oldName.lastIndexOf('.');

      extension = oldName.substring(lastIndex);
      newName = oldName.substring(0, lastIndex);
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
      target = RegExp(RegExp.escape(targetString), caseSensitive: caseSensitive);
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

class RuleRemove implements Rule {
  RuleRemove(
      this.targetString, // keyword to be searched and removed.
      int removeLimit, // 0: all matches; positive: from start; negative: from end.
      bool caseSensitive,
      bool isRegex,
      bool ignoreExtension) {
    ruleReplace = RuleReplace(targetString, '', removeLimit,
        caseSensitive, isRegex, ignoreExtension);
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

class RuleInsert implements Rule {
  RuleInsert(
    this.insert,
    this.insertIndex,
    this.fromStart,
    this.ignoreExtension,
  );

  final String insert; // string to be inserted
  final int insertIndex; // insert before character at index
  final bool fromStart; // true: count from start; false: from end.
  final bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName = oldName;
    String extension = '';

    if (ignoreExtension) {
      final lastIndex = oldName.lastIndexOf('.');

      extension = oldName.substring(lastIndex);
      newName = oldName.substring(0, lastIndex);
    }
    
    int index = insertIndex;

    if (!fromStart) {
      index = newName.length - index;
    }

    if (index < 0) {
      index = 0;
    } else if (index > newName.length) {
      index = newName.length;
    }

    newName = newName.substring(0, index) +
        insert +
        newName.substring(index);

    return newName + extension;
  }

  @override
  String toString() {
    return 'Insert "$insert" at char #$insertIndex from ${fromStart ? 'start' : 'end'}';
  }
}

import 'string_x.dart';

abstract class Rule {
  String newName(String oldName);

  @override
  String toString();
}

(String, String) splitFileName(String oldName, bool ignoreExtension) {
  String newName = oldName;
  String extension = '';

  if (ignoreExtension) {
    final lastIndex = oldName.lastIndexOf('.');

    extension = oldName.substring(lastIndex);
    newName = oldName.substring(0, lastIndex);
  }

  return (newName, extension);
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
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    Pattern target;
    String Function(Match) replacer;

    if (isRegex) {
      target = RegExp(targetString, caseSensitive: caseSensitive);
      replacer = (match) {
        List<String?> groups = match.groups(List<int>.generate(match.groupCount + 1, (index) => index));

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
    ruleReplace = RuleReplace(targetString, '', removeLimit, caseSensitive, isRegex, ignoreExtension);
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
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    int index = insertIndex;

    if (!fromStart) {
      index = newName.length - index;
    }

    if (index < 0) {
      index = 0;
    } else if (index > newName.length) {
      index = newName.length;
    }

    newName = newName.substring(0, index) + insert + newName.substring(index);

    return newName + extension;
  }

  @override
  String toString() {
    return 'Insert "$insert" at char #$insertIndex from ${fromStart ? 'start' : 'end'}';
  }
}

class RuleRearrange implements Rule {
  RuleRearrange(
    this.delimiter,
    this.order,
    this.ignoreExtension,
  );

  final String delimiter; // split delimiter
  final List<int> order; // true: count from start; false: from end.
  final bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    // split string
    List<String> substrings = newName.split(delimiter);

    // remove indexes out of limit
    final order = this.order.where((index) => index >= 1 && index <= substrings.length).toList();

    // rearrange substrings
    List<String> reorderedSubstrings = order.map((index) => substrings[index - 1]).toList();

    // join substrings
    String result = reorderedSubstrings.join(delimiter);

    return result + extension;
  }

  @override
  String toString() {
    return 'Rearrange: delimiter: "$delimiter", order: "$order".';
  }
}

class RuleTruncate implements Rule {
  RuleTruncate(
    this.startIndex,
    this.fromStart,
    this.direction,
    this.length,
    this.ignoreExtension,
  );

  final int startIndex; // count from
  final bool fromStart; // true: count from start, false: count from end.
  final bool direction; // truncate direction
  final int length; // truncate length
  final bool ignoreExtension;

  @override
  String newName(String oldName) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    int index = startIndex;

    if (fromStart) {
      index = newName.length + index;
    }

    if (index < 0) {
      index = 0;
    } else if (index >= newName.length) {
      index = newName.length;
    }

    if (direction) {
      newName = newName.substring(index, index + length);
    } else {
      newName = newName.substring(index - length + 1, index + 1);
    }

    return newName + extension;
  }

  @override
  String toString() {
    return 'Truncate.';
  }
}

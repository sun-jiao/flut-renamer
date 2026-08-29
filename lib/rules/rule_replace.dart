part of 'rule.dart';

class RuleReplace implements Rule {
  RuleReplace(
    this.targetString,
    this.replacementString,
    this.replaceLimit,
    this.withMetadata,
    this.caseSensitive,
    this.isRegex,
    this.ignoreExtension, {
    this.dateFormat = FileMetadata.defaultDateFormat,
  }
  );

  final String targetString; // target to be matched and replaced.
  final String replacementString; // `targetString` will be replaced to this.
  // 0: all matches; positive: from start; negative: from end.
  final int replaceLimit;
  final bool withMetadata; // true: replace metadata tag with metadata
  final bool caseSensitive;
  final bool isRegex;
  final bool ignoreExtension;
  final String dateFormat;

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

    String replacementString = this.replacementString;

    if (withMetadata) {
      await metadata!.init();
      replacementString = metadata.parse(
        replacementString,
        dateFormat: dateFormat,
      );
    }

    Pattern target;
    String Function(Match) replacer;

    if (isRegex) {
      target = RegExp(targetString, caseSensitive: caseSensitive);
      replacer = (match) {
        List<String?> groups =
            match.groups(List<int>.generate(match.groupCount + 1, (index) => index));

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
    return L10n.current.replaceToString(targetString, replacementString);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'Replace',
      'targetString': targetString,
      'replacementString': replacementString,
      'replaceLimit': replaceLimit,
      'withMetadata': withMetadata,
      'caseSensitive': caseSensitive,
      'isRegex': isRegex,
      'ignoreExtension': ignoreExtension,
      'dateFormat': dateFormat,
    };
  }

  factory RuleReplace.fromMap(Map<dynamic, dynamic> map) {
    return RuleReplace(
      map['targetString'] as String,
      map['replacementString'] as String,
      map['replaceLimit'] as int,
      map['withMetadata'] as bool,
      map['caseSensitive'] as bool,
      map['isRegex'] as bool,
      map['ignoreExtension'] as bool,
      dateFormat: map['dateFormat'] as String? ?? FileMetadata.defaultDateFormat,
    );
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) => showReplaceDialog(context, onSave, this);
}

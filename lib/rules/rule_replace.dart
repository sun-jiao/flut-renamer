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
  });

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
  bool get requiresMetadata =>
      targetString.isNotEmpty &&
      withMetadata &&
      metadataTagRegex.hasMatch(replacementString);

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

    final randomStringRegex = RegExp(r'\{RandomString(?::(\d+))?\}');
    if (randomStringRegex.hasMatch(replacementString)) {
      replacementString = replacementString.replaceAllMapped(
        randomStringRegex,
        (match) {
          final parsedLength = int.tryParse(match.group(1) ?? '') ?? 8;
          final length = parsedLength.clamp(1, 32);
          return Uuid().v4().replaceAll('-', '').substring(0, length);
        },
      );
    }

    if (requiresMetadata) {
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
        return replacementString.replaceAllMapped(RegExp(r'\\(\d+)'), (
          reference,
        ) {
          final index = int.tryParse(reference.group(1)!);
          if (index == null || index > match.groupCount) return '';
          return match.group(index) ?? '';
        });
      };
    } else {
      target =
          RegExp(RegExp.escape(targetString), caseSensitive: caseSensitive);
      replacer = (match) => replacementString;
    }

    if (replaceLimit == 0) {
      newName = newName.replaceAllMapped(target, replacer);
    } else {
      final matches = target.allMatches(newName).toList();
      final count = replaceLimit.abs().clamp(0, matches.length).toInt();
      final selectedMatches = replaceLimit > 0
          ? matches.take(count)
          : matches.skip(matches.length - count);

      // Work backwards so each match range continues to refer to the original
      // name, even when earlier replacements change its length or add targets.
      for (final match in selectedMatches.toList().reversed) {
        newName = newName.replaceRange(
          match.start,
          match.end,
          replacer(match),
        );
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
      dateFormat:
          map['dateFormat'] as String? ?? FileMetadata.defaultDateFormat,
    );
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) =>
      showReplaceDialog(context, onSave, this);
}

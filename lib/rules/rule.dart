import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pinyin/pinyin.dart';
import 'package:cyrtranslit/cyrtranslit.dart' as cyrtranslit;
import 'package:uuid/uuid.dart';

import '../dialogs/increment_dialog.dart';
import '../dialogs/insert_dialog.dart';
import '../dialogs/rearrange_dialog.dart';
import '../dialogs/remove_dialog.dart';
import '../dialogs/replace_dialog.dart';
import '../dialogs/transliterate_dialog.dart';
import '../dialogs/truncate_dialog.dart';
import '../l10n/l10n.dart';
import '../entity/transliterate.dart';
import '../tools/file_metadata.dart';

part 'base_rule.dart';

part 'rule_increment.dart';
part 'rule_insert.dart';
part 'rule_rearrange.dart';
part 'rule_remove.dart';
part 'rule_replace.dart';
part 'rule_transliterate.dart';
part 'rule_truncate.dart';

class RuleFactory {
  static Rule? fromMap(Map<dynamic, dynamic> map) {
    final type = map['type'];
    if (type is! String) return null;

    switch (type) {
      case 'Replace':
        if (!_matchesSchema(
          map,
          required: const {
            'type',
            'targetString',
            'replacementString',
            'replaceLimit',
            'withMetadata',
            'caseSensitive',
            'isRegex',
            'ignoreExtension',
          },
          optional: const {
            'dateFormat',
          },
        )) {
          return null;
        }
        return RuleReplace.fromMap(map);
      case 'Remove':
        if (!_matchesSchema(
          map,
          required: const {
            'type',
            'targetString',
            'removeLimit',
            'caseSensitive',
            'isRegex',
            'ignoreExtension',
          },
        )) {
          return null;
        }
        return RuleRemove.fromMap(map);
      case 'Insert':
        if (!_matchesSchema(
              map,
              required: const {
                'type',
                'insert',
                'insertIndex',
                'toEnd',
                'withMetadata',
                'ignoreExtension',
              },
              optional: const {
                'dateFormat',
              },
            ) ||
            !_isNonNegativeInt(map['insertIndex'])) {
          return null;
        }
        return RuleInsert.fromMap(map);
      case 'Increment':
        if (!_matchesSchema(
              map,
              required: const {
                'type',
                'prefix',
                'startIndex',
                'step',
                'omitDash',
                'ignoreExtension',
              },
              optional: const {
                'minimumDigits',
              },
            ) ||
            !_isNonNegativeInt(map['startIndex']) ||
            !_isNonNegativeInt(map['step']) ||
            (map.containsKey('minimumDigits') &&
                !_isNonNegativeInt(map['minimumDigits']))) {
          return null;
        }
        return RuleIncrement.fromMap(map);
      case 'Rearrange':
        if (!_matchesSchema(
              map,
              required: const {
                'type',
                'delimiter',
                'order',
                'ignoreExtension',
              },
            ) ||
            !_isPositiveIntList(map['order'])) {
          return null;
        }
        return RuleRearrange.fromMap(map);
      case 'Transliterate':
        if (!_matchesSchema(
              map,
              required: const {
                'type',
                'transliterateType',
                'langCode',
              },
            ) ||
            !_isTransliterateType(map['transliterateType']) ||
            !_isLanguageCode(map['langCode'])) {
          return null;
        }
        return RuleTransliterate.fromMap(map);
      case 'Truncate':
        if (!_matchesSchema(
              map,
              required: const {
                'type',
                'index1',
                'index2',
                'i1toEnd',
                'i2toEnd',
                'ignoreExtension',
                'keepBetween',
              },
            ) ||
            !_isNonNegativeInt(map['index1']) ||
            !_isNonNegativeInt(map['index2'])) {
          return null;
        }
        return RuleTruncate.fromMap(map);
      default:
        return null;
    }
  }

  static bool _matchesSchema(
    Map<dynamic, dynamic> map, {
    required Set<String> required,
    Set<String> optional = const {},
  }) {
    final allowed = {...required, ...optional};
    if (!map.keys.every((key) => key is String && allowed.contains(key)) ||
        !map.keys.toSet().containsAll(required)) {
      return false;
    }

    for (final key in required) {
      if (!_hasExpectedType(key, map[key])) return false;
    }
    for (final key in optional) {
      if (map.containsKey(key) && !_hasExpectedType(key, map[key])) {
        return false;
      }
    }
    return true;
  }

  static bool _hasExpectedType(String key, dynamic value) {
    switch (key) {
      case 'type':
      case 'prefix':
      case 'targetString':
      case 'replacementString':
      case 'insert':
      case 'delimiter':
      case 'dateFormat':
      case 'langCode':
        return value is String;
      case 'startIndex':
      case 'step':
      case 'minimumDigits':
      case 'replaceLimit':
      case 'removeLimit':
      case 'insertIndex':
      case 'transliterateType':
      case 'index1':
      case 'index2':
        return value is int;
      case 'order':
        return value is List;
      case 'omitDash':
      case 'ignoreExtension':
      case 'withMetadata':
      case 'caseSensitive':
      case 'isRegex':
      case 'toEnd':
      case 'i1toEnd':
      case 'i2toEnd':
      case 'keepBetween':
        return value is bool;
      default:
        return false;
    }
  }

  static bool _isNonNegativeInt(dynamic value) => value is int && value >= 0;

  static bool _isPositiveIntList(dynamic value) =>
      value is List &&
      value.isNotEmpty &&
      value.every((item) => item is int && item > 0);

  static bool _isTransliterateType(dynamic value) =>
      value is int && Transliterate.values.any((type) => type.value == value);

  static bool _isLanguageCode(dynamic value) =>
      value is String && RuleTransliterate.validLangCodes.contains(value);
}

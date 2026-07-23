import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pinyin/pinyin.dart';
import 'package:cyrtranslit/cyrtranslit.dart' as cyrtranslit;

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
import '../tools/ex_string.dart';

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
    final type = map['type'] as String?;
    switch (type) {
      case 'Replace':
        return RuleReplace.fromMap(map);
      case 'Remove':
        return RuleRemove.fromMap(map);
      case 'Insert':
        return RuleInsert.fromMap(map);
      case 'Increment':
        return RuleIncrement.fromMap(map);
      case 'Rearrange':
        return RuleRearrange.fromMap(map);
      case 'Transliterate':
        return RuleTransliterate.fromMap(map);
      case 'Truncate':
        return RuleTruncate.fromMap(map);
      default:
        return null;
    }
  }
}

import 'dart:async';

import 'package:flut_renamer/dialogs/rearrange_dialog.dart';
import 'package:flut_renamer/dialogs/remove_dialog.dart';
import 'package:flut_renamer/dialogs/replace_dialog.dart';
import 'package:flut_renamer/dialogs/transliterate_dialog.dart';
import 'package:flut_renamer/dialogs/truncate_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:pinyin/pinyin.dart';
import 'package:cyrtranslit/cyrtranslit.dart' as cyrtranslit;

import '../dialogs/increment_dialog.dart';
import '../dialogs/insert_dialog.dart';
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

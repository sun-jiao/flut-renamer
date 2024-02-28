import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static SharedPreferences? _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    _fileOrDir = pref.getString(_fileOrDirKey) ?? _fileOrDir;
    _onlySelected = pref.getBool(_onlySelectedKey) ?? _onlySelected;
    _removeRenamed = pref.getBool(_removeRenamedKey) ?? _removeRenamed;
    _removeRules = pref.getBool(_removeRulesKey) ?? _removeRules;
    _ruleName = pref.getString(_ruleNameKey) ?? _ruleName;
    _iosDoNotRemindAgain = pref.getBool(_iosDoNotRemindAgainKey) ?? _iosDoNotRemindAgain;
  }

  static SharedPreferences get pref => _pref!;

  static bool get initialed => _pref != null;

  static const _fileOrDirKey = 'file_or_dir';
  static const _onlySelectedKey = 'only_selected';
  static const _removeRenamedKey = 'remove_renamed';
  static const _removeRulesKey = 'remove_rules';
  static const _ruleNameKey = 'rule_name';
  static const _iosDoNotRemindAgainKey = 'ios_do_not_remind_again';

  static String _fileOrDir = 'Files';
  static String get fileOrDir => _fileOrDir;
  static set fileOrDir(String value) {
    _fileOrDir = value;
    pref.setString(_fileOrDirKey, value);
  }

  static bool _onlySelected = false;
  static bool get onlySelected => _onlySelected;
  static set onlySelected(bool value) {
    _onlySelected = value;
    pref.setBool(_onlySelectedKey, value);
  }

  static bool _removeRenamed = true;
  static bool get removeRenamed => _removeRenamed;
  static set removeRenamed(bool value) {
    _removeRenamed = value;
    pref.setBool(_removeRenamedKey, value);
  }

  static bool _removeRules = false;
  static bool get removeRules => _removeRules;
  static set removeRules(bool value) {
    _removeRules = value;
    pref.setBool(_removeRulesKey, value);
  }

  static String _ruleName = 'Replace';
  static String get ruleName => _ruleName;
  static set ruleName(String value) {
    _ruleName = value;
    pref.setString(_ruleNameKey, value);
  }

  static bool _iosDoNotRemindAgain = false;
  static bool get iosDoNotRemindAgain => _iosDoNotRemindAgain;
  static set iosDoNotRemindAgain(bool value) {
    _iosDoNotRemindAgain = value;
    pref.setBool(_iosDoNotRemindAgainKey, value);
  }
}

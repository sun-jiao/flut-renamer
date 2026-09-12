import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('loads persisted settings and writes each changed setting', () async {
    SharedPreferences.setMockInitialValues({
      'file_or_dir': 'Directories',
      'only_selected': true,
      'remove_renamed': false,
      'remove_rules': true,
      'rule_name': 'Insert',
      'do_not_remind_again': true,
    });

    await Shared.init();
    expect(Shared.fileOrDir, 'Directories');
    expect(Shared.onlySelected, isTrue);
    expect(Shared.removeRenamed, isFalse);
    expect(Shared.removeRules, isTrue);
    expect(Shared.ruleName, 'Insert');
    expect(Shared.doNotRemindAgain, isTrue);

    Shared.fileOrDir = 'Files';
    Shared.onlySelected = false;
    Shared.removeRenamed = true;
    Shared.removeRules = false;
    Shared.ruleName = 'Replace';
    Shared.doNotRemindAgain = false;

    expect(Shared.pref.getString('file_or_dir'), 'Files');
    expect(Shared.pref.getBool('only_selected'), isFalse);
    expect(Shared.pref.getBool('remove_renamed'), isTrue);
    expect(Shared.pref.getBool('remove_rules'), isFalse);
    expect(Shared.pref.getString('rule_name'), 'Replace');
    expect(Shared.pref.getBool('do_not_remind_again'), isFalse);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/pages/rules_page.dart';
import 'package:flut_renamer/rules/rule.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await L10n.load(const Locale('en'));
    SharedPreferences.setMockInitialValues({'remove_rules': true});
    await Shared.init();
  });

  testWidgets('adds and clears rules while notifying the file page',
      (tester) async {
    final key = GlobalKey<RulesPageState>();
    var changes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RulesPage(
            key: key,
            onRuleChanged: () => changes++,
          ),
        ),
      ),
    );
    await tester.pump();
    key.currentState!.clearRule();

    final rule = RuleInsert('prefix-', 0, false, false, true);
    key.currentState!.addRule(rule);
    await tester.pump();

    expect(key.currentState!.rules, [rule]);
    expect(changes, 1);
    expect(find.text(rule.toString()), findsOneWidget);

    key.currentState!.clearRule();
    await tester.pump();

    expect(key.currentState!.rules, isEmpty);
  });
}

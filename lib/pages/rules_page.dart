import 'package:flutter/material.dart';
import 'package:renamer/dialogs/increment_dialog.dart';

import '../dialogs/truncate_dialog.dart';
import '../dialogs/rearrange_dialog.dart';
import '../dialogs/remove_dialog.dart';
import '../dialogs/replace_dialog.dart';
import '../dialogs/insert_dialog.dart';
import '../entity/sharedpref.dart';
import '../rules/rule.dart';
import '../tools/responsive.dart';
import '../widget/custom_drop.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key, required this.onRuleChanged});

  final VoidCallback onRuleChanged;

  @override
  State<RulesPage> createState() => RulesPageState();
}

class RulesPageState extends State<RulesPage> {
  final List<Rule> _rules = [];
  List<Rule> get rules => _rules;

  void clearRule() {
    if (Shared.removeRules) {
      setState(() {
        rules.clear();
      });
    }
  }

  void addRule(Rule rule) {
    setState(() {
      _rules.add(rule);
    });
    widget.onRuleChanged.call();
  }

  void showRuleDialog() {
    switch (Shared.ruleName) {
      case 'Replace':
        showReplaceDialog(context, addRule);
      case 'Remove':
        showRemoveDialog(context, addRule);
      case 'Insert':
        showInsertDialog(context, addRule);
      case 'Increment':
        showIncrementDialog(context, addRule);
      case 'Rearrange':
        showRearrangeDialog(context, addRule);
      case 'Truncate':
        showTruncateDialog(context, addRule);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: CustomDrop<String>(
              value: Shared.ruleName,
              onChanged: (String? newValue) {
                setState(() {
                  Shared.ruleName = newValue!;
                });
              },
              items: const <String>[
                'Replace',
                'Remove',
                'Insert',
                'Increment',
                'Rearrange',
                'Truncate',
              ],
            ),
            title: ElevatedButton(
              onPressed: showRuleDialog,
              child: const Text('Add Rule'),
            ),
            trailing: Tooltip(
              message: 'Clear All',
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _rules.clear();
                  });
                  widget.onRuleChanged.call();
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _rules.removeAt(oldIndex);
                  _rules.insert(newIndex, item);
                });
                widget.onRuleChanged.call();
              },
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                final item = _rules[index];
                return ListTile(
                  title: Text(item.toString()),
                  key: ValueKey(item),
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _rules.removeAt(index);
                      });
                      widget.onRuleChanged.call();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                );
              },
              itemCount: _rules.length,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: Shared.removeRules,
                onChanged: (value) {
                  setState(() {
                    Shared.removeRules = value ?? Shared.removeRules;
                  });
                },
              ),
              const Responsive(
                mobile: Text('Remove all rules\nafter renaming'),
                desktop: Text('Remove all rules after renaming'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

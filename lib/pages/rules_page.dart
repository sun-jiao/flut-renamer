import 'package:flutter/material.dart';

import '../dialogs/transliterate_dialog.dart';
import '../dialogs/increment_dialog.dart';
import '../dialogs/truncate_dialog.dart';
import '../dialogs/rearrange_dialog.dart';
import '../dialogs/remove_dialog.dart';
import '../dialogs/replace_dialog.dart';
import '../dialogs/insert_dialog.dart';
import '../entity/sharedpref.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/custom_drop.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key, required this.onRuleChanged});

  final VoidCallback onRuleChanged;

  @override
  State<RulesPage> createState() => RulesPageState();
}

final List<Rule> _rules = [];

class RulesPageState extends State<RulesPage> {
  List<Rule> get rules => _rules;

  void clearRule() {
    if (Shared.removeRules) {
      setState(() {
        _rules.clear();
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
      case 'Transliterate':
        showTransliterateDialog(context, addRule);
      case 'Truncate':
        showTruncateDialog(context, addRule);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDrop<String>(
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
                  'Transliterate',
                  'Truncate',
                ],
                tToStr: (obj) => {
                  'Replace': L10n.current.replace,
                  'Remove': L10n.current.remove,
                  'Insert': L10n.current.insert,
                  'Increment': L10n.current.increment,
                  'Rearrange': L10n.current.rearrange,
                  'Transliterate': L10n.current.transliterate,
                  'Truncate': L10n.current.truncate,
                }[obj]!,
                semanticsAppendix: L10n.current.semanticsRuleDropdownButton,
              ),
              TextButton(
                onPressed: showRuleDialog,
                child: Text(L10n.current.addRule),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _rules.clear();
                  });
                  widget.onRuleChanged.call();
                },
                child: Text(L10n.current.removeAll),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_rules.isEmpty)
          Expanded(
            child: Center(
              child: SizedBox(
                width: 175,
                child: Text(
                  L10n.current.rulesSequentially,
                  semanticsLabel: L10n.current.semanticsReorderableList,
                ),
              ),
            ),
          )
        else
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
                  onTap: () {
                    item.openDialog(
                      context,
                      (rule) {
                        setState(() {
                          _rules[index] = rule;
                        });
                        widget.onRuleChanged.call();
                      },
                    );
                  },
                );
              },
              itemCount: _rules.length,
            ),
          ),
      ],
    );
  }
}

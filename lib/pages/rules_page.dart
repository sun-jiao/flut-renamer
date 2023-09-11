import 'package:flutter/material.dart';
import 'package:renamer/dialogs/replace.dart';

import '../dialogs/insert.dart';
import '../entity/rule.dart';
import '../widget/custom_drop.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key, required this.onRuleChanged});

  final VoidCallback onRuleChanged;

  @override
  State<RulesPage> createState() => RulesPageState();
}

class RulesPageState extends State<RulesPage> {
  final List<Rule> _rules = [];
  String _addRule = 'Replace';
  bool _clearRule = false;

  List<Rule> get rules => _rules;

  void clearRule() {
    if (_clearRule) {
      setState(() {
        rules.clear();
      });
    }
  }

  void showRuleDialog() {
    switch (_addRule) {
      case 'Replace':
        showReplaceDialog(
          context,
          (rule) {
            setState(() {
              _rules.add(rule);
            });
            widget.onRuleChanged.call();
          },
        );
      case 'Remove':
        showRemoveDialog(
          context,
          (rule) {
            setState(() {
              _rules.add(rule);
            });
            widget.onRuleChanged.call();
          },
        );
      case 'Insert':
        showInsertDialog(
          context,
              (rule) {
            setState(() {
              _rules.add(rule);
            });
            widget.onRuleChanged.call();
          },
        );
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
              value: _addRule,
              onChanged: (String? newValue) {
                setState(() {
                  _addRule = newValue!;
                });
              },
              items: const <String>['Replace', 'Remove', 'Insert'],
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
                value: _clearRule,
                onChanged: (value) {
                  setState(() {
                    _clearRule = value ?? _clearRule;
                  });
                },
              ),
              const Text('Also remove all rules'),
            ],
          )
        ],
      ),
    );
  }
}

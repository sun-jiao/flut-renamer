import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yaml_writer/yaml_writer.dart';

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
import '../tools/rule_persistence.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key, required this.onRuleChanged});

  final VoidCallback onRuleChanged;

  @override
  State<RulesPage> createState() => RulesPageState();
}

final List<Rule> _rules = [];

class RulesPageState extends State<RulesPage> {
  List<Rule> get rules => _rules;

  @override
  void initState() {
    super.initState();
    _loadTempRules();
  }

  Future<void> _loadTempRules() async {
    final rules = await RulePersistence.loadRules();
    if (rules.isNotEmpty) {
      setState(() {
        _rules.clear();
        _rules.addAll(rules);
      });
      widget.onRuleChanged.call();
    }
  }

  Future<void> _saveTempRules() async {
    await RulePersistence.saveRules(_rules);
  }

  void clearRule() {
    if (Shared.removeRules) {
      setState(() {
        _rules.clear();
      });
      _saveTempRules();
    }
  }

  void addRule(Rule rule) {
    setState(() {
      _rules.add(rule);
    });
    widget.onRuleChanged.call();
    _saveTempRules();
  }

  void _manualSaveRules() async {
    final List<Map<String, dynamic>> ruleMaps = _rules.map((r) => r.toMap()).toList();
    final yamlWriter = YamlWriter();
    final yamlString = yamlWriter.write(ruleMaps);
    List<int> bomBytes = [0xEF, 0xBB, 0xBF];  // UTF-8 byte-order mark
    List<int> contentBytes = utf8.encode(yamlString);

    Uint8List bytes = Uint8List.fromList(bomBytes + contentBytes);

    await FilePicker.saveFile(
      dialogTitle: L10n.current.saveRules,
      fileName: 'rules.yaml',
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml'],
      bytes: bytes,
    );
  }

  void _manualLoadRules() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml'],
    );

    if (result != null && result.files.single.path != null) {
      final rules = await RulePersistence.loadRules(sourceFile: File(result.files.single.path!));
      setState(() {
        _rules.clear();
        _rules.addAll(rules);
      });
      widget.onRuleChanged.call();
      _saveTempRules();
    }
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.add),
                tooltip: L10n.current.addRule,
                onSelected: (newValue) {
                  setState(() {
                    Shared.ruleName = newValue;
                  });
                  showRuleDialog();
                },
                itemBuilder: (BuildContext context) => <String>[
                  'Replace',
                  'Remove',
                  'Insert',
                  'Increment',
                  'Rearrange',
                  'Transliterate',
                  'Truncate',
                ].map((String value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text({
                      'Replace': L10n.current.replace,
                      'Remove': L10n.current.remove,
                      'Insert': L10n.current.insert,
                      'Increment': L10n.current.increment,
                      'Rearrange': L10n.current.rearrange,
                      'Transliterate': L10n.current.transliterate,
                      'Truncate': L10n.current.truncate,
                    }[value]!),
                  );
                }).toList(),
              ),
              IconButton(
                onPressed: _manualSaveRules,
                icon: const Icon(Icons.save),
                tooltip: L10n.current.saveRules,
              ),
              IconButton(
                onPressed: _manualLoadRules,
                icon: const Icon(Icons.file_open),
                tooltip: L10n.current.loadRules,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _rules.clear();
                  });
                  widget.onRuleChanged.call();
                  _saveTempRules();
                },
                icon: const Icon(Icons.delete),
                tooltip: L10n.current.removeAll,
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
                _saveTempRules();
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
                      _saveTempRules();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    item.openDialog(
                      context,
                      (rule) {
                        setState(() {
                          _rules[index] = rule;
                        });
                        widget.onRuleChanged.call();
                        _saveTempRules();
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

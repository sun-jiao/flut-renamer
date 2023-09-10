import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/rule.dart';

void showReplaceDialog(BuildContext context, Function(Rule) onSave) =>
    showDialog(
        context: context,
        builder: (context) => ReplaceDialog(
              onSave: onSave,
              remove: false,
            ));

void showRemoveDialog(BuildContext context, Function(Rule) onSave) =>
    showDialog(
        context: context,
        builder: (context) => ReplaceDialog(
              onSave: onSave,
              remove: true,
            ));

class ReplaceDialog extends StatefulWidget {
  const ReplaceDialog({super.key, required this.onSave, required this.remove});

  final Function(Rule) onSave;
  final bool remove;

  @override
  State<ReplaceDialog> createState() => _ReplaceDialogState();
}

class _ReplaceDialogState extends State<ReplaceDialog> {
  TextEditingController targetController = TextEditingController();
  TextEditingController replacementController = TextEditingController();
  TextEditingController limitController = TextEditingController(
    text: '0',
  );
  bool fromStart = true;
  bool caseSensitive = false;
  bool isRegex = false;
  bool ignoreExtension = true;
  late bool remove;
  late String ruleName;

  @override
  void initState() {
    remove = widget.remove;
    ruleName = remove ? 'Remove' : 'Replace';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Rule: $ruleName'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: targetController,
              decoration: InputDecoration(labelText: '$ruleName Target'),
            ),
            if (!remove)
              TextFormField(
                controller: replacementController,
                decoration: const InputDecoration(labelText: 'Replacement'),
              ),
            TextFormField(
              controller: limitController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // 只允许数字
              ],
              decoration: InputDecoration(labelText: '$ruleName Limit'),
            ),
            CheckboxListTile(
              title: const Text('From start'),
              value: fromStart,
              onChanged: (value) {
                setState(() {
                  fromStart = value ?? fromStart;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Case sensitive'),
              value: caseSensitive,
              onChanged: (value) {
                setState(() {
                  caseSensitive = value ?? caseSensitive;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Is regex'),
              value: isRegex,
              onChanged: (value) {
                setState(() {
                  isRegex = value ?? isRegex;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Ignore Extension'),
              value: ignoreExtension,
              onChanged: (value) {
                setState(() {
                  ignoreExtension = value ?? ignoreExtension;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String targetString = targetController.text;
            String replacementString = replacementController.text;
            int replaceLimit = int.tryParse(limitController.text) ?? 0;
            replaceLimit = replaceLimit.abs() * (fromStart ? 1 : -1);
            final Rule rule;
            if (remove) {
              rule = RuleRemove(targetString,
                  replaceLimit, caseSensitive, isRegex, ignoreExtension);
            } else {
              rule = RuleReplace(targetString, replacementString,
                  replaceLimit, caseSensitive, isRegex, ignoreExtension);
            }
            widget.onSave.call(rule);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

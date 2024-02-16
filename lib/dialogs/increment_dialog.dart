import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/constants.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';

void showIncrementDialog(BuildContext context, Function(Rule) onSave) => showDialog(
      context: context,
      builder: (context) => IncrementDialog(
        onSave: onSave,
      ),
    );

class IncrementDialog extends StatefulWidget {
  const IncrementDialog({super.key, required this.onSave});

  final Function(Rule) onSave;

  @override
  State<IncrementDialog> createState() => _IncrementDialogState();
}

class _IncrementDialogState extends State<IncrementDialog> {
  TextEditingController prefixController = TextEditingController();
  TextEditingController indexController = TextEditingController(
    text: '0',
  );
  TextEditingController stepController = TextEditingController(
    text: '0',
  );
  bool omitDash = false;
  bool ignoreExtension = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Rule: Increment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: prefixController,
              decoration: const InputDecoration(labelText: 'Prefix'),
            ),
            box,
            TextFormField(
              controller: indexController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: const InputDecoration(labelText: 'Start index'),
            ),
            box,
            TextFormField(
              controller: stepController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: const InputDecoration(labelText: 'Index incremental step'),
            ),
            CheckboxTile(
              title: const Text('Omit dash'),
              value: omitDash,
              onChanged: (value) {
                setState(() {
                  omitDash = value ?? omitDash;
                });
              },
            ),
            CheckboxTile(
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
            String prefix = prefixController.text;
            int startIndex = int.tryParse(indexController.text) ?? 0;
            int step = int.tryParse(stepController.text) ?? 0;

            final Rule rule = RuleIncrement(
              prefix,
              startIndex,
              step,
              omitDash,
              ignoreExtension,
            );

            widget.onSave.call(rule);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

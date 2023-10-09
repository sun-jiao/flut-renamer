import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';

void showTruncateDialog(BuildContext context, Function(Rule) onSave) =>
    showDialog(
      context: context,
      builder: (context) => TruncateDialog(
        onSave: onSave,
      ),
    );

class TruncateDialog extends StatefulWidget {
  const TruncateDialog({super.key, required this.onSave});

  final Function(Rule) onSave;

  @override
  State<TruncateDialog> createState() => _TruncateDialogState();
}

class _TruncateDialogState extends State<TruncateDialog> {
  TextEditingController startController = TextEditingController(
    text: '0',
  );
  TextEditingController lengthController = TextEditingController(
    text: '0',
  );
  bool fromStart = true; // true: count from start, false: count from end.
  bool direction = true; // truncate direction
  bool ignoreExtension = true;
  bool keep = true; // true: keep chars in ranges, false: remove in range

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Rule: Insert'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: startController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: const InputDecoration(labelText: 'Start index'),
            ),
            TextFormField(
              controller: lengthController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: const InputDecoration(labelText: 'Selection length'),
            ),
            CheckboxTile(
              title: const Text('From start'),
              value: fromStart,
              onChanged: (value) {
                setState(() {
                  fromStart = value ?? fromStart;
                });
              },
            ),
            CheckboxTile(
              title: const Text('Going forward'),
              value: direction,
              onChanged: (value) {
                setState(() {
                  direction = value ?? direction;
                });
              },
            ),
            CheckboxTile(
              title: const Text('Keep characters'),
              value: keep,
              onChanged: (value) {
                setState(() {
                  keep = value ?? keep;
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
            int startIndex = int.tryParse(startController.text) ?? 0;
            int length = int.tryParse(lengthController.text) ?? 0;

            final Rule rule = RuleTruncate(
              startIndex,
              fromStart,
              direction,
              length,
              ignoreExtension,
              keep,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/constants.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';

void showRearrangeDialog(BuildContext context, Function(Rule) onSave) => showDialog(
      context: context,
      builder: (context) => RearrangeDialog(
        onSave: onSave,
      ),
    );

class RearrangeDialog extends StatefulWidget {
  const RearrangeDialog({super.key, required this.onSave});

  final Function(Rule) onSave;

  @override
  State<RearrangeDialog> createState() => _RearrangeDialogState();
}

class _RearrangeDialogState extends State<RearrangeDialog> {
  TextEditingController delimiterController = TextEditingController();
  TextEditingController intArrayController = TextEditingController();
  bool ignoreExtension = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Rule: Rearrange'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: delimiterController,
              decoration: const InputDecoration(labelText: 'Rearrange delimiter'),
            ),
            box,
            TextFormField(
              controller: intArrayController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                // Only number and comma allowed
                FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Rearrange order (numbers separated with comma)',
              ),
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
            String delimiter = delimiterController.text;
            String order = intArrayController.text;
            List<int> orderList = order.split(',').map((s) => int.tryParse(s.trim()) ?? 0).toList();

            final Rule rule = RuleRearrange(delimiter, orderList, ignoreExtension);

            widget.onSave.call(rule);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

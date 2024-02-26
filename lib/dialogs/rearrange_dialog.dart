import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/constants.dart';
import '../l10n/l10n.dart';
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
      title: Text('${L10n.current.addRule}: ${L10n.current.rearrange}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.current.descriptionRearrange),
            TextFormField(
              controller: delimiterController,
              decoration: InputDecoration(labelText: L10n.current.rearrangeDelimiter),
            ),
            box,
            TextFormField(
              controller: intArrayController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                // Only number and comma allowed
                FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
              ],
              decoration: InputDecoration(
                labelText: L10n.current.rearrangeOrderLabel,
                hintText: L10n.current.rearrangeOrderHint,
              ),
            ),
            CheckboxTile(
              title: Text(L10n.current.ignoreExtension),
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
          child: Text(L10n.current.cancel),
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
          child: Text(L10n.current.add),
        ),
      ],
    );
  }
}

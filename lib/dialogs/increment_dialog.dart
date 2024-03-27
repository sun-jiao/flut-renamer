import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';
import '../widget/custom_dialog.dart';

void showIncrementDialog(BuildContext context, Function(Rule) onSave, [RuleIncrement? rule]) => showDialog(
      context: context,
      builder: (context) => IncrementDialog(
        onSave: onSave,
        rule: rule,
      ),
    );

class IncrementDialog extends StatefulWidget {
  const IncrementDialog({super.key, required this.onSave, required this.rule});

  final Function(Rule) onSave;
  final RuleIncrement? rule;

  @override
  State<IncrementDialog> createState() => _IncrementDialogState();
}

class _IncrementDialogState extends State<IncrementDialog> {
  TextEditingController prefixController = TextEditingController();
  TextEditingController indexController = TextEditingController(
    text: '0',
  );
  TextEditingController stepController = TextEditingController(
    text: '1',
  );
  bool omitDash = false;
  bool ignoreExtension = true;

  @override
  void initState() {
    if (widget.rule != null) {
      prefixController.text = widget.rule!.prefix;
      indexController.text = widget.rule!.index.toString();
      stepController.text = widget.rule!.step.toString();
      omitDash = widget.rule!.omitDash;
      ignoreExtension = widget.rule!.ignoreExtension;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text('${L10n.current.addRule}: ${L10n.current.increment}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.current.descriptionIncrement),
            TextFormField(
              controller: prefixController,
              decoration: InputDecoration(labelText: L10n.current.prefix),
            ),
            box,
            TextFormField(
              controller: indexController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: InputDecoration(labelText: L10n.current.startIndex),
            ),
            box,
            TextFormField(
              controller: stepController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: InputDecoration(labelText: L10n.current.indexIncrementalStep),
            ),
            CheckboxTile(
              title: Text(L10n.current.omitDash),
              value: omitDash,
              onChanged: (value) {
                setState(() {
                  omitDash = value ?? omitDash;
                });
              },
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
          child: Text(L10n.current.add),
        ),
      ],
    );
  }
}

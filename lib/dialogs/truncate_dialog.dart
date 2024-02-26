import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';
import '../widget/custom_dialog.dart';

void showTruncateDialog(BuildContext context, Function(Rule) onSave) => showDialog(
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
  TextEditingController i1Controller = TextEditingController(text: '0');
  TextEditingController i2Controller = TextEditingController(text: '0');
  bool i1toEnd = false; // true: negative (Xth-to-last), false: positive (Xth)
  bool i2toEnd = false; // true: negative (Xth-to-last), false: positive (Xth)
  bool ignoreExtension = true;
  bool keepBetween = true; // true: keep chars in ranges, false: remove in range

  Widget _getRow(TextEditingController con, bool toEnd, VoidCallback callback) => Row(
    children: [
      Expanded(child: TextFormField(
        controller: con,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
        ],
        decoration: InputDecoration(labelText: L10n.current.indexOne),
      ),),
      TextButton(
        child: Text(L10n.current.toLast, style: TextStyle(
          color: toEnd ? null : Colors.grey,
        ),),
        onPressed: () {
          setState(() {
            callback.call();
          });
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text('${L10n.current.addRule}: ${L10n.current.truncate}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(L10n.current.descriptionTruncate),
            _getRow(i1Controller, i1toEnd, () => i1toEnd = !i1toEnd),
            box,
            _getRow(i2Controller, i2toEnd, () => i2toEnd = !i2toEnd),
            ListTile(
              title: TextButton(
                child: Text(keepBetween ? L10n.current.keepCharacters : L10n.current.removeCharacters),
                onPressed: () {
                  setState(() {
                    keepBetween = !keepBetween;
                  });
                },
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
            int index1 = int.tryParse(i1Controller.text) ?? 0;
            int index2 = int.tryParse(i2Controller.text) ?? 0;

            final Rule rule = RuleTruncate(
              index1,
              index2,
              i1toEnd,
              i2toEnd,
              ignoreExtension,
              keepBetween,
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

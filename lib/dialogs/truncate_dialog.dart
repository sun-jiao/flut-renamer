import 'package:flutter/material.dart';
import 'package:renamer/widget/text_field_with_direction.dart';

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
  ValueNotifier<bool> i1toEnd = ValueNotifier(false); // true: negative (Xth-to-last), false: positive (Xth)
  ValueNotifier<bool> i2toEnd = ValueNotifier(false); // true: negative (Xth-to-last), false: positive (Xth)
  bool ignoreExtension = true;
  bool keepBetween = true; // true: keep chars in ranges, false: remove in range

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
            DirectionTextField(con: i1Controller, toEnd: i1toEnd, labelText: L10n.current.indexOne),
            box,
            DirectionTextField(con: i2Controller, toEnd: i2toEnd, labelText: L10n.current.indexTwo),
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
              i1toEnd.value,
              i2toEnd.value,
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

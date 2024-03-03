import 'package:flutter/material.dart';
import 'package:renamer/widget/metadata_tile.dart';

import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';
import '../widget/custom_dialog.dart';
import '../widget/text_field_with_direction.dart';

void showInsertDialog(BuildContext context, Function(Rule) onSave) => showDialog(
      context: context,
      builder: (context) => InsertDialog(
        onSave: onSave,
      ),
    );

class InsertDialog extends StatefulWidget {
  const InsertDialog({super.key, required this.onSave});

  final Function(Rule) onSave;

  @override
  State<InsertDialog> createState() => _InsertDialogState();
}

class _InsertDialogState extends State<InsertDialog> {
  TextEditingController textController = TextEditingController();
  TextEditingController indexController = TextEditingController(
    text: '0',
  );
  ValueNotifier<bool> withMetadata = ValueNotifier(false);
  ValueNotifier<bool> toEnd = ValueNotifier(false);
  bool get fromStart => !toEnd.value;
  bool beforeIndex = true; // true: insert before index; false: after
  bool ignoreExtension = true;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text('${L10n.current.addRule}: ${L10n.current.insert}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.current.descriptionInsert),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(labelText: L10n.current.insertedText),
            ),
            box,
            DirectionTextField(con: indexController, toEnd: toEnd, labelText: L10n.current.insertIndex),
            CheckboxTile(
              title: Text(L10n.current.insertBeforeIndex),
              value: beforeIndex,
              onChanged: (value) {
                setState(() {
                  beforeIndex = value ?? beforeIndex;
                });
              },
            ),
            MetadataTile(textController: textController, withMetadata: withMetadata),
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
            String insertText = textController.text;
            int insertIndex = int.tryParse(indexController.text) ?? 0;

            final Rule rule = RuleInsert(
              insertText,
              insertIndex,
              fromStart,
              withMetadata.value,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renamer/dialogs/metadata_dialog.dart';
import 'package:renamer/tools/ex_text_editing_controller.dart';

import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';

void showInsertDialog(BuildContext context, Function(Rule) onSave) =>
    showDialog(
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
  bool withMetadata = false;
  bool fromStart = true;
  bool beforeIndex = true; // true: insert before index; false: after
  bool ignoreExtension = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Rule: Insert'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Insert Text'),
            ),
            TextFormField(
              controller: indexController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: const InputDecoration(labelText: 'Insert Index'),
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
              title: const Text('Insert before index'),
              value: beforeIndex,
              onChanged: (value) {
                setState(() {
                  beforeIndex = value ?? beforeIndex;
                });
              },
            ),
            CheckboxTile(
              title: const Text(
                'Metadata tags ',
                softWrap: false,
              ),
              value: withMetadata,
              onChanged: (value) {
                setState(() {
                  withMetadata = value ?? withMetadata;
                });
              },
              trailing: IconButton(
                onPressed: () {
                  showMetadataDialog(context, (tag) {
                    textController.insertTag(tag, context);
                    setState(() {
                      withMetadata = true;
                    });
                  });
                },
                icon: const Icon(Icons.info_outline_rounded),
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
            String insertText = textController.text;
            int insertIndex = int.tryParse(indexController.text) ?? 0;

            final Rule rule = RuleInsert(
              insertText,
              insertIndex,
              fromStart,
              withMetadata,
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

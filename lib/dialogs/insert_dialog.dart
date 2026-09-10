import 'package:flutter/material.dart';

import '../widget/metadata_tile.dart';
import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';
import '../widget/custom_dialog.dart';
import '../widget/date_format_dropdown.dart';
import '../widget/text_field_with_direction.dart';
import '../tools/file_metadata.dart';

void showInsertDialog(
  BuildContext context,
  Function(Rule) onSave, [
  RuleInsert? rule,
]) =>
    showDialog(
      context: context,
      builder: (context) => InsertDialog(
        onSave: onSave,
        rule: rule,
      ),
    );

class InsertDialog extends StatefulWidget {
  const InsertDialog({super.key, required this.onSave, this.rule});

  final Function(Rule) onSave;
  final RuleInsert? rule;

  @override
  State<InsertDialog> createState() => _InsertDialogState();
}

class _InsertDialogState extends State<InsertDialog> {
  TextEditingController textController = TextEditingController();
  TextEditingController indexController = TextEditingController(
    text: '0',
  );
  TextEditingController randomLengthController = TextEditingController(
    text: '8',
  );
  ValueNotifier<bool> withMetadata = ValueNotifier(false);
  ValueNotifier<bool> toEnd = ValueNotifier(false);
  ValueNotifier<bool> useRandomString = ValueNotifier(false);
  bool ignoreExtension = true;
  String dateFormat = FileMetadata.defaultDateFormat;

  @override
  void initState() {
    if (widget.rule != null) {
      textController.text = widget.rule!.insert;
      indexController.text = widget.rule!.insertIndex.toString();
      withMetadata.value = widget.rule!.withMetadata;
      toEnd.value = widget.rule!.toEnd;
      ignoreExtension = widget.rule!.ignoreExtension;
      dateFormat = widget.rule!.dateFormat;
      final randomStringToken = RegExp(r'^\{RandomString(?::(\d+))?\}$');
      final match = randomStringToken.firstMatch(widget.rule!.insert);
      useRandomString.value = match != null;
      if (match?.group(1) case final length?) {
        randomLengthController.text = length;
      }
      if (useRandomString.value) {
        withMetadata.value = false;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text('${L10n.current.addRule}: ${L10n.current.insert}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(L10n.current.descriptionInsert),
            ValueListenableBuilder<bool>(
              valueListenable: useRandomString,
              builder: (context, useRandom, child) => Column(
                children: [
                  CheckboxTile(
                    title: Text(L10n.current.insertRandomString),
                    value: useRandom,
                    onChanged: (value) {
                      setState(() {
                        useRandomString.value = value ?? useRandom;
                        if (value == true) {
                          textController.clear();
                          withMetadata.value = false;
                        }
                      });
                    },
                  ),
                  if (useRandom)
                    TextFormField(
                      controller: randomLengthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: L10n.current.randomStringLength,
                        hintText: L10n.current.randomStringLengthHint,
                      ),
                    )
                  else
                    TextFormField(
                      controller: textController,
                      decoration:
                          InputDecoration(labelText: L10n.current.insertedText),
                    ),
                ],
              ),
            ),
            box,
            DirectionTextField(
              con: indexController,
              toEnd: toEnd,
              labelText: L10n.current.insertIndex,
            ),
            // Text(L10n.current.insertBeforeIndex, style: const TextStyle(fontSize: 13),),
            if (!useRandomString.value) ...[
              MetadataTile(
                textController: textController,
                withMetadata: withMetadata,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: withMetadata,
                builder: (context, usesMetadata, child) => usesMetadata
                    ? DateFormatDropdown(
                        value: dateFormat,
                        onChanged: (value) =>
                            setState(() => dateFormat = value),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
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
            String insertText;
            if (useRandomString.value) {
              final parsedLength =
                  int.tryParse(randomLengthController.text) ?? 8;
              final length = parsedLength.clamp(1, 32);
              insertText = '{RandomString:$length}';
            } else {
              insertText = textController.text;
            }
            int insertIndex = int.tryParse(indexController.text) ?? 0;

            final Rule rule = RuleInsert(
              insertText,
              insertIndex,
              toEnd.value,
              withMetadata.value,
              ignoreExtension,
              dateFormat: dateFormat,
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

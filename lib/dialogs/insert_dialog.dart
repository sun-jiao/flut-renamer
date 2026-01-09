import 'package:flutter/material.dart';

import '../widget/metadata_tile.dart';
import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';
import '../widget/custom_dialog.dart';
import '../widget/text_field_with_direction.dart';

void showInsertDialog(BuildContext context, Function(Rule) onSave, [RuleInsert? rule]) => showDialog(
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

  @override
  void initState() {
    if (widget.rule != null) {
      textController.text = widget.rule!.insert;
      indexController.text = widget.rule!.insertIndex.toString();
      withMetadata.value = widget.rule!.withMetadata;
      toEnd.value = widget.rule!.toEnd;
      // 检查是否使用随机字符串
      useRandomString.value = widget.rule!.insert.contains('{RandomString');
      // 如果是随机字符串，尝试提取长度
      if (useRandomString.value) {
        final RegExp lengthRegex = RegExp(r'\{RandomString(?::(\d+))?\}');
        final match = lengthRegex.firstMatch(widget.rule!.insert);
        if (match != null && match.group(1) != null) {
          randomLengthController.text = match.group(1)!;
        }
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
              builder: (context, useRandom, child) {
                return Column(
                  children: [
                    CheckboxTile(
                      title: Text('插入随机字符串'),
                      value: useRandom,
                      onChanged: (value) {
                        setState(() {
                          useRandomString.value = value ?? useRandom;
                          if (value == true) {
                            // 如果启用随机字符串，清除文本输入框
                            textController.text = '';
                          }
                        });
                      },
                    ),
                    if (useRandom) ...[
                      TextFormField(
                        controller: randomLengthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '随机字符串长度',
                          hintText: '8',
                        ),
                        validator: (value) {
                          final int? length = int.tryParse(value ?? '');
                          if (length == null || length < 1 || length > 32) {
                            return '长度应在1-32之间';
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      TextFormField(
                        controller: textController,
                        decoration: InputDecoration(labelText: L10n.current.insertedText),
                      ),
                    ],
                  ],
                );
              },
            ),
            box,
            DirectionTextField(con: indexController, toEnd: toEnd, labelText: L10n.current.insertIndex),
            // Text(L10n.current.insertBeforeIndex, style: const TextStyle(fontSize: 13),),
            if (!useRandomString.value) ...[
              MetadataTile(textController: textController, withMetadata: withMetadata),
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
              int length = int.tryParse(randomLengthController.text) ?? 8;
              // 确保长度在合理范围内
              length = length.clamp(1, 32);
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

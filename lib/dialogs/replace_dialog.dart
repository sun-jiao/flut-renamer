import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../tools/ex_text_editing_controller.dart';
import '../rules/rule.dart';
import '../widget/checkbox_tile.dart';
import 'metadata_dialog.dart';

void showReplaceDialog(BuildContext context, Function(Rule) onSave) => showDialog(
      context: context,
      builder: (context) => ReplaceDialog(
        onSave: onSave,
        remove: false,
      ),
    );

class ReplaceDialog extends StatefulWidget {
  const ReplaceDialog({super.key, required this.onSave, required this.remove});

  final Function(Rule) onSave;
  final bool remove;

  @override
  State<ReplaceDialog> createState() => _ReplaceDialogState();
}

class _ReplaceDialogState extends State<ReplaceDialog> {
  TextEditingController targetController = TextEditingController();
  TextEditingController replacementController = TextEditingController();
  TextEditingController limitController = TextEditingController(
    text: '0',
  );
  bool fromStart = true;
  bool withMetadata = false;
  bool caseSensitive = false;
  bool isRegex = false;
  bool ignoreExtension = true;
  late bool remove;
  late String ruleName;

  @override
  void initState() {
    remove = widget.remove;
    ruleName = remove ? L10n.current.remove : L10n.current.replace;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${L10n.current.addRule}: $ruleName'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(remove ? L10n.current.descriptionRemove : L10n.current.descriptionReplace),
            TextFormField(
              controller: targetController,
              decoration: InputDecoration(labelText: '$ruleName ${L10n.current.target}'),
            ),
            box,
            if (!remove)
              TextFormField(
                controller: replacementController,
                decoration: InputDecoration(labelText: L10n.current.replacement),
              ),
            if (!remove) box,
            TextFormField(
              controller: limitController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: InputDecoration(labelText: '$ruleName ${L10n.current.limit}'),
            ),
            CheckboxTile(
              title: Text(L10n.current.fromStart),
              value: fromStart,
              onChanged: (value) {
                setState(() {
                  fromStart = value ?? fromStart;
                });
              },
            ),
            CheckboxTile(
              title: Text(
                L10n.current.metadataTags,
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
                    replacementController.insertTag(tag, context);
                    setState(() {
                      withMetadata = true;
                    });
                  });
                },
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ),
            CheckboxTile(
              title: Text(L10n.current.caseSensitive),
              value: caseSensitive,
              onChanged: (value) {
                setState(() {
                  caseSensitive = value ?? caseSensitive;
                });
              },
            ),
            CheckboxTile(
              title: Text(L10n.current.isRegex),
              value: isRegex,
              onChanged: (value) {
                setState(() {
                  isRegex = value ?? isRegex;
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
            String targetString = targetController.text;
            String replacementString = replacementController.text;
            int replaceLimit = int.tryParse(limitController.text) ?? 0;
            replaceLimit = replaceLimit.abs() * (fromStart ? 1 : -1);
            final Rule rule;
            if (remove) {
              rule = RuleRemove(
                targetString,
                replaceLimit,
                caseSensitive,
                isRegex,
                ignoreExtension,
              );
            } else {
              rule = RuleReplace(
                targetString,
                replacementString,
                replaceLimit,
                withMetadata,
                caseSensitive,
                isRegex,
                ignoreExtension,
              );
            }
            widget.onSave.call(rule);
            Navigator.of(context).pop();
          },
          child: Text(L10n.current.add),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../entity/transliterate.dart';
import '../l10n/l10n.dart';
import '../widget/custom_dialog.dart';
import '../widget/custom_drop.dart';
import 'package:cyrtranslit/cyrtranslit.dart' as cyrtranslit;

import '../rules/rule.dart';

void showTransliterateDialog(BuildContext context, Function(Rule) onSave) => showDialog(
      context: context,
      builder: (context) => TransliterateDialog(
        onSave: onSave,
      ),
    );

class TransliterateDialog extends StatefulWidget {
  const TransliterateDialog({super.key, required this.onSave});

  final Function(Rule) onSave;

  @override
  State<TransliterateDialog> createState() => _TransliterateDialogState();
}

class _TransliterateDialogState extends State<TransliterateDialog> {
  Transliterate type = Transliterate.values.first;
  String? langCode;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Text('${L10n.current.addRule}: ${L10n.current.transliterate}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(L10n.current.descriptionTransliterate),
            CustomDrop<Transliterate>(
              value: type,
              onChanged: (Transliterate? newValue) {
                setState(() {
                  type = newValue!;
                });
              },
              items: Transliterate.values,
            ),
            if ([Transliterate.cyrillic2Latin, Transliterate.latin2Cyrillic].contains(type))
              Row(
                children: [
                  Text(L10n.current.language),
                  CustomDrop<String>(
                    value: cyrtranslit.supported().first,
                    onChanged: (String? newValue) {
                      setState(() {
                        langCode = newValue;
                      });
                    },
                    items: cyrtranslit.supported().map((e) => e.toString()).toList(),
                    tToStr: (e) => RuleTransliterate.langCodeMap[e]!,
                  ),
                ],
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
            final Rule rule = RuleTransliterate(type, langCode: langCode);

            widget.onSave.call(rule);
            Navigator.of(context).pop();
          },
          child: Text(L10n.current.add),
        ),
      ],
    );
  }
}

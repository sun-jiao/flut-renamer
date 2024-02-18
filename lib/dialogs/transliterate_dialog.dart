import 'package:flutter/material.dart';
import '../entity/transliterate.dart';
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
    return AlertDialog(
      title: const Text('Add Rule: Transliterate'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const Text('Language: '),
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final Rule rule = RuleTransliterate(type, langCode: langCode);

            widget.onSave.call(rule);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

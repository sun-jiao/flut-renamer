import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../widget/custom_dialog.dart';
import '../widget/text_field_with_direction.dart';

extension on Rule {
  Dialog buildDialog(BuildContext context) {
    final List<Widget> fields = [];

    for (final field in dialogConfig.fields) {
      final widgetType = field.appendixData['widgetType'] as String?;
      switch (field.value) {
        case final String value:
          TextEditingController controller = TextEditingController(
            text: value,
          );

          field.appendixData['controller'] = controller;

          fields.add(
            TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: field.description),
            ),
          );
          continue;
        case final int value:
          TextEditingController controller = TextEditingController(
            text: value.abs().toString(),
          );

          field.appendixData['controller'] = controller;

          fields.add(
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: InputDecoration(labelText: field.description),
            ),
          );
          continue;
        case final DirectionalInt value:
          TextEditingController controller = TextEditingController(
            text: value.value.abs().toString(),
          );

          field.appendixData['controller'] = controller;

          fields.add(DirectionTextField(con: controller, toEnd: value.direction, labelText: field.description));
          continue;
        case final bool value:

          continue;
      }
    }

    return CustomDialog(
      title: Text('${L10n.current.addRule}: ${dialogConfig.title}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(dialogConfig.description),
            ...fields,
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

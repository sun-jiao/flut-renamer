import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';

class DirectionTextField extends StatefulWidget {
  const DirectionTextField({
    super.key,
    required this.con,
    required this.toEnd,
    required this.labelText,
  });

  final TextEditingController con;
  final ValueNotifier<bool> toEnd;
  final String labelText;

  @override
  State<DirectionTextField> createState() => _DirectionTextFieldState();
}

class _DirectionTextFieldState extends State<DirectionTextField> {
  @override
  Widget build(BuildContext context) {
    return _getRow(widget.con, widget.toEnd, widget.labelText);
  }

  Widget _getRow(TextEditingController con, ValueNotifier<bool> toEnd, String labelText) => Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: con,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字
              ],
              decoration: InputDecoration(labelText: labelText),
            ),
          ),
          TextButton(
            child: Text(
              L10n.current.toLast,
              semanticsLabel: L10n.current.semanticSwitchNumberToStartAndToEnd(toEnd.value ? 0 : 1),
              style: TextStyle(
                color: toEnd.value ? null : Colors.grey,
              ),
            ),
            onPressed: () {
              setState(() {
                toEnd.value = !toEnd.value;
              });
            },
          ),
        ],
      );
}

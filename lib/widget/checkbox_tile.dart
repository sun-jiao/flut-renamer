import 'package:flutter/material.dart';

class CheckboxTile extends StatelessWidget {
  const CheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.trailing,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: value,
        onChanged: onChanged,
      ),
      title: title,
      trailing: trailing,
    );
  }
}

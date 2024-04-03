import 'package:flutter/material.dart';

class CustomDialog extends Dialog {
  const CustomDialog({super.key, this.title, this.content, this.actions});
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      semanticLabel: '',
      title: title,
      actions: actions,
      content: Container(
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
        child: content,
      ),
    );
  }
}

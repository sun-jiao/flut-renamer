import 'package:flutter/material.dart';

import 'replace_dialog.dart';
import '../rules/rule.dart';

void showRemoveDialog(BuildContext context, Function(Rule) onSave) =>
    showDialog(
      context: context,
      builder: (context) => ReplaceDialog(
        onSave: onSave,
        remove: true,
      ),
    );

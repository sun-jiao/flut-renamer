import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../tools/file_metadata.dart';

class DateFormatDropdown extends StatelessWidget {
  const DateFormatDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: L10n.current.dateFormat),
      items: FileMetadata.dateFormats
          .map(
            (format) => DropdownMenuItem(
              value: format,
              child: Text(format),
            ),
          )
          .toList(),
      onChanged: (format) {
        if (format != null) {
          onChanged(format);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class CustomDrop<T> extends StatelessWidget {
  CustomDrop({
    super.key,
    required this.value,
    this.onChanged,
    required this.items,
    String Function(T)? tToStr,
    this.semanticsAppendix = '',
  }) {
    this.tToStr = tToStr ?? (t) => t is String ? t : t.toString();
  }

  final T value;
  final ValueChanged<T?>? onChanged;
  final List<T> items;
  late final String Function(T) tToStr;
  final String semanticsAppendix;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: Semantics(
        excludeSemantics: true,
        label: L10n.current.semanticsDropdownButton(tToStr.call(value)),
        child: DropdownButton<T>(
          value: value,
          focusColor: Colors.transparent,
          underline: const SizedBox(),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<T>>((T tValue) {
            final text = tToStr.call(tValue);
            return DropdownMenuItem<T>(
              value: tValue,
              child: Text(text, semanticsLabel: text + semanticsAppendix,),
            );
          }).toList(),
        ),
      ),
    );
  }
}

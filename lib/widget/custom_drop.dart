import 'package:flutter/material.dart';

class CustomDrop<T> extends StatelessWidget {
  CustomDrop({
    super.key,
    required this.value,
    this.onChanged,
    required this.items,
    String Function(T)? tToStr,
  }) {
    this.tToStr = tToStr ?? (t) => t is String ? t : t.toString();
  }

  final T value;
  final ValueChanged<T?>? onChanged;
  final List<T> items;
  late final String Function(T) tToStr;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<T>(
        value: value,
        focusColor: Colors.transparent,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(tToStr.call(value)),
          );
        }).toList(),
      ),
    );
  }
}

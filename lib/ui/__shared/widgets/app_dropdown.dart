import 'package:flutter/material.dart';

class AppDropDown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String? prefixText;
  final Function(T?) onChanged;

  const AppDropDown({
    super.key,
    required this.value,
    required this.items,
    this.prefixText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      items: items
          .map(
            (T level) => DropdownMenuItem<T>(
              value: level,
              child: Text('${prefixText ?? ''} $level'),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

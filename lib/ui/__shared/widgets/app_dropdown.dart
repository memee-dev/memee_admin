import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final borderRadius = BorderRadius.circular(2.sp);
    final padding = EdgeInsets.symmetric(horizontal: 4.w);
    return Container(
      //padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 0.2.sp,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          padding: padding,
          borderRadius: borderRadius,
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Template on Widget {
  Widget paddingH({double? h}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: h ?? 16.w),
        child: this,
      );
  Widget paddingV({double? v}) => Padding(
        padding: EdgeInsets.symmetric(vertical: v ?? 12.w),
        child: this,
      );
  Widget paddingE({double? value}) => Padding(
        padding: EdgeInsets.all(value ?? 16.w),
        child: this,
      );
  Widget paddingS({double? h, double? v}) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: h ?? 16.w,
          vertical: v ?? 12.w,
        ),
        child: this,
      );

  Widget show(bool show) => show ? this : const SizedBox.shrink();

  Widget gapBottom(double value) => Column(
        children: [this, SizedBox(height: value)]
      );

  Widget gapRight(double value) => Row(
        children: [this, SizedBox(width: value)],
      );
}

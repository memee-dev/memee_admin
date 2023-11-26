import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> showDetailedDialog(
  BuildContext context, {
  required Widget child,
  double? width,
  double? height,
}) async {
  return await showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          child: child,
        ),
      );
    },
  );
}

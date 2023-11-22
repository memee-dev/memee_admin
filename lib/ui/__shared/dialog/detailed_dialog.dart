import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> showDetailedDialog(
  BuildContext context, {
  required Widget child,
}) async {
  return await showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              child: child,
            ),
          ],
        ),
      );
    },
  );
}

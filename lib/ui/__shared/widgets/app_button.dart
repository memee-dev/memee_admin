import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/app_strings.dart';

class AppButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Color bgColor;
  final Color textColor;
  final Function() onTap;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.bgColor = Colors.amber,
    this.textColor = Colors.black,
    this.isLoading = false,
  });

  const AppButton.positive({
    super.key,
    this.label = AppStrings.save,
    required this.onTap,
    this.bgColor = Colors.amber,
    this.textColor = Colors.black,
    this.isLoading = false,
  });

  const AppButton.negative({
    super.key,
    this.label = AppStrings.cancel,
    required this.onTap,
    this.bgColor = Colors.black,
    this.textColor = Colors.amber,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: textColor),
              ),
      ),
    );
  }
}

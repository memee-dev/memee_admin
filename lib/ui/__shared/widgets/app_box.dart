import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

class AppBox extends StatelessWidget {
  final Widget? child;
  final Color? bgColor;
  final Color? borderColor;
  final String? text;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final double? radius;
  const AppBox({
    super.key,
    this.child,
    this.bgColor,
    this.borderColor,
    this.padding,
    this.onTap,
    this.text,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text != null)
            Text(
              text!,
              style: Theme.of(context).textTheme.labelSmall,
            ).gapBottom(2.h),
          Container(
            padding: padding ??
                EdgeInsets.symmetric(
                  vertical: 6.h,
                  horizontal: 2.w,
                ),
            decoration: BoxDecoration(
              color: bgColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(radius ?? 4.r),
              border: Border.all(
                color: borderColor ?? bgColor ?? Colors.black,
                width: 0.5,
              ),
            ),
            child: child,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

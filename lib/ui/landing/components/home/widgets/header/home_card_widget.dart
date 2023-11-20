import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

class HomeCard extends StatelessWidget {
  final String label;
  final String count;
  final Color textColor;
  final Color bgColor;
  const HomeCard({
    super.key,
    required this.label,
    required this.count,
    this.bgColor = Colors.amber,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin:EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 38.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 28.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textColor),
          ).gapBottom(16),
          Text(
            count,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: textColor),
          ).gapBottom(16),
        ],
      ),
    );
  }
}

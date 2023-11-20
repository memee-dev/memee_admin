import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

class AwaitingOrdersWidget extends StatelessWidget {
  final Color textColor;
 
  const AwaitingOrdersWidget({
    super.key,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.awaitingOrders,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: textColor),
          ).gapBottom(12.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 182.h, horizontal: 52.w),
            decoration: const BoxDecoration(color: Colors.amber),
            child: Text(
              'wdddww',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

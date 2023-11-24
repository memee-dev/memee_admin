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
      color: Colors.red.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppStrings.awaitingOrders,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: textColor,
                ),
          ).gapBottom(12.h),
          //! TODO: create a recent orders list,
          Text(
            'wdddww',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}

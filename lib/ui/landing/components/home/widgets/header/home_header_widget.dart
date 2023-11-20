import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/landing/components/home/widgets/header/home_card_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HomeCard(
          label: AppStrings.awaitingOrders,
          count: '23',
        ).expanded(),
        SizedBox(width: 4.w),
        const HomeCard(
          label: AppStrings.onGoingOrders,
          count: '34',
        ).expanded(),
        SizedBox(width: 4.w),
        const HomeCard(
          label: AppStrings.completedOrders,
          count: '56',
        ).expanded(),
        SizedBox(width: 4.w),
        const HomeCard(
          label: AppStrings.cancelledOrders,
          count: '12',
        ).expanded(),
      ],
    );
  }
}

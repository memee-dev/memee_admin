import 'package:flutter/material.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/landing/components/home/widgets/header/home_card_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HomeCard(label: AppStrings.awaitingOrders,
        count: '23',
        ),
        HomeCard(label: AppStrings.onGoingOrders,
        count: '34',
        ),
        HomeCard(label: AppStrings.completedOrders,
        count: '56',
        ),
        HomeCard(label: AppStrings.cancelledOrders,
        count: '12',
        ),
      ],
    );
  }
}
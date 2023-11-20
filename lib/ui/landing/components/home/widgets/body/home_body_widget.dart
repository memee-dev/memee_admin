import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'awaiting_orders_widget.dart';
import 'ongoing_orders_widget.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         OnGoingOrdersWidget(),
       
         AwaitingOrdersWidget()
      ],
    );
  }
}

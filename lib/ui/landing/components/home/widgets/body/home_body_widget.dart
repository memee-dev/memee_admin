import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import '../../../../../__shared/widgets/app_divider.dart';
import 'awaiting_orders_widget.dart';
import 'ongoing_orders_widget.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnGoingOrdersWidget().expanded(flex: 2),
          AppDivider.V(width: 1.h).paddingH(h: 2.w),
          const AwaitingOrdersWidget().expanded(flex: 1),
        ],
      ),
    );
  }
}

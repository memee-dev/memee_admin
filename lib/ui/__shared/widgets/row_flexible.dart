import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowFlexibleWidget extends StatelessWidget {
  final Widget rChild, lChild;
  final MainAxisAlignment? mainAxisAlignment;
  const RowFlexibleWidget({
    super.key,
    required this.rChild,
    required this.lChild,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: lChild,
        ),
        SizedBox(width: 16.w),
        Flexible(
          child: rChild,
        ),
      ],
    );
  }
}

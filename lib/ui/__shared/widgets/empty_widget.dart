import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  final String label;
  const EmptyWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        label,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}

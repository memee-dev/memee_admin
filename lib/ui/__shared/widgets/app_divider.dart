import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

enum HV {
  horizontal,
  vertical,
}

// ignore: must_be_immutable
class AppDivider extends StatelessWidget {
  HV? type;
  double? height;
  double? width;

  AppDivider.H({super.key, this.height}) {
    type = HV.horizontal;
  }

  AppDivider.V({super.key, this.width}) {
    type = HV.vertical;
  }

  @override
  Widget build(BuildContext context) {
    return type == HV.vertical
        ? Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppDivider2(
                height: height ?? 1.r,
                width: width ?? 1.r,
              ).expanded(),
            ],
          ).paddingH(h: 1.r)
        : Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppDivider2(
                height: height ?? 1.r,
                width: width ?? 1.r,
              ).expanded(),
            ],
          ).paddingV(v: 1.r);
  }
}

class AppDivider2 extends StatelessWidget {
  final double height;
  final double width;
  const AppDivider2({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }
}

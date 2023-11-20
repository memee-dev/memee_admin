import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/landing/components/home/widgets/body/home_body_widget.dart';
import 'package:memee_admin/ui/landing/components/home/widgets/header/home_header_widget.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const HomeHeaderWidget(),
        Divider(thickness: .2.h,),
        const HomeBodyWidget()
      ],
    );
  }
}

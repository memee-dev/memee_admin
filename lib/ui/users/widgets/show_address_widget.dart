import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/user_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/__shared/widgets/row_flexible.dart';

import '../../__shared/widgets/utils.dart';

class ShowAddress extends StatelessWidget {
  final bool enableEdit;
  final AddressModel address;
  const ShowAddress({
    super.key,
    required this.enableEdit,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        children: [
          RowFlexibleWidget(
            lChild: parseIcon(address.type),
            rChild: Align(
              alignment: Alignment.centerRight,
              child: AppSwitch(
                label: AppStrings.defaultt,
                value: address.defaultt,
                enableEdit: enableEdit,
                onTap: (bool val) {
                  if (enableEdit) {}
                },
              ),
            ),
          ).gapBottom(16.h),
          RowFlexibleWidget(
            lChild: AppTextField(
              controller: TextEditingController()..text = address.no,
              label: AppStrings.no,
              readOnly: !enableEdit,
            ),
            rChild: AppTextField(
              controller: TextEditingController()..text = address.street,
              label: AppStrings.street,
              readOnly: !enableEdit,
            ),
          ).gapBottom(8.h),
          RowFlexibleWidget(
            lChild: AppTextField(
              controller: TextEditingController()..text = address.area,
              label: AppStrings.area,
              readOnly: !enableEdit,
            ),
            rChild: AppTextField(
              controller: TextEditingController()..text = address.city,
              label: AppStrings.city,
              readOnly: !enableEdit,
            ),
          ).gapBottom(8.h),
          RowFlexibleWidget(
            lChild: AppTextField(
              controller: TextEditingController()..text = address.landmark,
              label: AppStrings.landmark,
              readOnly: !enableEdit,
            ),
            rChild: AppTextField(
              controller: TextEditingController()..text = address.pincode,
              label: AppStrings.pinCode,
              readOnly: !enableEdit,
            ),
          ),
        ],
      ),
    );
  }
}

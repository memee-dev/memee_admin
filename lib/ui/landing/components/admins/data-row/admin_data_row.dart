import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/admins/admins_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/models/admin_model.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/landing/components/admins/widgets/admin_detailed_widget.dart';

import '../../../../__shared/dialog/detailed_dialog.dart';

DataRow dataRow(
  BuildContext context,{
  required AdminModel admin,
  required Function() onDelete,
  required Function(bool?)? onSelectChanged,
}
  
) {
  return DataRow(
    cells: [
      DataCell(Text(admin.id)),
      DataCell(Text(admin.name)),
      DataCell(Text(admin.email)),
      DataCell(Text(admin.adminLevell)),
      DataCell(
        AppSwitch(
          value: admin.active,
          onTap: (bool val) {
            admin.active = val;
            locator.get<AdminCubit>().updateAdmin(admin);
          },
        ),
      ),
    ],
    onSelectChanged: (selected) async {
      final result = await showDetailedDialog(
        context,
        child: AdminDetailedWidget(admin: admin),
      );
      if (result != null && result is AdminModel) {
        admin = result;
      }
    },
  );
}

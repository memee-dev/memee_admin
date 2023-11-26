import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/models/dl_executive_model.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';

DataRow dlExecutiveDataRow(
  BuildContext context,
  {
  required DlExecutiveModel dlExecutive,
  required Function() onDelete,
  required Function(bool?)? onSelectChanged,
}
) {
  return DataRow(
    cells: [
      DataCell(Text(dlExecutive.name)),
      DataCell(Text(dlExecutive.email)),
      DataCell(Text(dlExecutive.phoneNumber)),
      DataCell(
        AppSwitch(
          value: dlExecutive.alloted,
          onTap: (bool val) {
            dlExecutive.alloted = val;
            locator.get<DlExecutiveCubit>().updateDlExecutive(dlExecutive);
          },
        ),
      ),
      DataCell(
        AppSwitch(
          value: dlExecutive.active,
          onTap: (bool val) {
            dlExecutive.active = val;
            locator.get<DlExecutiveCubit>().updateDlExecutive(dlExecutive);
          },
        ),
      ),
    ],
    onSelectChanged: onSelectChanged
  );
}

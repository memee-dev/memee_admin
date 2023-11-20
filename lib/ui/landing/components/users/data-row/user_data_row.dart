import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/users/users_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/landing/components/users/widgets/user_detailed_widget.dart';

import '../../../../../models/user_model.dart';
import '../../../../__shared/dialog/detailed_dialog.dart';

DataRow userDataRow(
  BuildContext context,
  UserModel user,
) {
  return DataRow(
    cells: [
      DataCell(Text(user.id)),
      DataCell(Text(user.userName)),
      DataCell(Text(user.email)),
      DataCell(Text(user.phoneNumber)),
      DataCell(
        AppSwitch(
          value: user.verified,
          onTap: (bool val) {
            user.verified = val;
            locator.get<UserCubit>().updateUser(user);
          },
        ),
      ),
      DataCell(
        AppSwitch(
          value: user.active,
          onTap: (bool val) {
            user.active = val;
            locator.get<UserCubit>().updateUser(user);
          },
        ),
      ),
    ],
    onSelectChanged: (selected) async {
      final result = await showDetailedDialog(
        context,
        child: UserDetailed(user: user),
      );
      if (result != null && result is UserModel) {
        user = result;
      }
    },
  );
}

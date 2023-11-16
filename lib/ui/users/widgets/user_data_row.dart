import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/users/users_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/users/widgets/user_detailed.dart';

import '../../../models/user_model.dart';
import '../../__shared/dialog/detailed_dialog.dart';

DataRow userDataRow(
  BuildContext context,
  UserModel user,
) {
  return DataRow(
    cells: [
      DataCell(Text(user.id)),
      DataCell(Text(user.userName)),
      DataCell(Text(user.email)),
      DataCell(
          Text('${user.defaultAddress().no}, ${user.defaultAddress().area}')),
      DataCell(Text(user.phoneNumber)),
      DataCell(Text(user.verified ? 'Verified' : 'Not verified')),
      DataCell(
        AppSwitch(
          status: user.active,
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

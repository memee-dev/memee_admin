import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/admins/admins_cubit.dart';
import 'package:memee_admin/models/admin_model.dart';
import 'package:memee_admin/ui/admins/widgets/admin_detailed.dart';

import '../../../blocs/hide_and_seek/hide_and_seek_cubit.dart';
import '../../../core/initializer/app_di_registration.dart';
import '../../../core/shared/app_strings.dart';
import '../../__shared/dialog/confirmation_dialog.dart';
import '../../__shared/dialog/detailed_dialog.dart';

DataRow dataRow(context, AdminModel admin) {
  final activeCubit = locator.get<HideAndSeekCubit>();
  return DataRow(
    cells: [
      DataCell(Text(admin.id)),
      DataCell(Text(admin.name)),
      DataCell(Text(admin.email)),
      DataCell(Text(admin.adminLevell)),
      DataCell(
        BlocBuilder<HideAndSeekCubit, bool>(
          bloc: activeCubit..initialValue(admin.active),
          builder: (context, state) {
            return SwitchListTile(
              value: state,
              onChanged: (value) async {
                await showConfirmationDialog(
                  context,
                  onTap: (bool val) {
                    if (val) {
                      admin.active = !state;
                      activeCubit.change();
                      context.read<AdminsCubit>().updateAdmin(admin);
                    }
                    Navigator.pop(context);
                  },
                );
              },
              title: Text(
                admin.active ? AppStrings.active : AppStrings.disabled,
              ),
            );
          },
        ),
      ),
    ],
    onSelectChanged: (selected) async {
      final result = await showDetailedDialog(
        context,
        child: AdminDetailed(admin: admin),
      );
      if (result != null && result is AdminModel) {
        admin = result;
      }
    },
  );
}

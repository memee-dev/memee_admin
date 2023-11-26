import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/admins/admins_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/admin_model.dart';
import 'package:memee_admin/ui/__shared/enum/doc_type.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import '../../../../../blocs/index/index_cubit.dart';
import '../../../../../blocs/toggle/toggle_cubit.dart';
import '../../../../__shared/widgets/app_button.dart';
import '../../../../__shared/widgets/app_dropdown.dart';
import '../../../../__shared/widgets/app_switch.dart';
import '../../../../__shared/widgets/utils.dart';

class AdminDetailedWidget extends StatelessWidget {
  final AdminModel? admin;
  const AdminDetailedWidget({
    super.key,
    this.admin,
  });

  @override
  Widget build(BuildContext context) {
    final _adminCubit = locator.get<AdminCubit>();
    final _toggleCubit = locator.get<ToggleCubit>();
    final _switchCubit = locator.get<ToggleCubit>();
    final _saveCubit = locator.get<ToggleCubit>();
    final indexCubit = locator.get<IndexCubit>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();

    final List<int> adminLevel = [0, 1, 2];

    late String selectedId = '';
    late String selectedName = '';
    late String selectedEmail = '';
    late bool selectedStatus = false;
    late bool isLoading = false;
    late int selectedAdminLevel = adminLevel[0];
    DocType docType = getDocType<AdminModel>(admin, false);
    _resetForm() {
      if (admin != null) {
        selectedId = admin!.id;
        selectedName = admin!.name;
        selectedEmail = admin!.email;
        selectedAdminLevel = admin!.adminLevel;
        selectedStatus = admin!.active;
      }
    }

    _resetForm();

    final paddingButton = EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h);

    return BlocBuilder<ToggleCubit, bool>(
      bloc: _toggleCubit,
      builder: (_, state) {
        double hfWidth = 75.w;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.admins,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                if ((docType != DocType.add))
                  IconButton(
                    onPressed: () {
                      docType = getDocType<AdminModel>(
                          admin, docType != DocType.edit);
                      _toggleCubit.change();
                    },
                    icon: Icon(
                      docType == DocType.edit
                          ? Icons.close_outlined
                          : Icons.edit_outlined,
                    ),
                  ),
              ],
            ).sizedBoxW(hfWidth).gapBottom(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedId.isNotEmpty ? 'ID: ${admin!.id}' : AppStrings.add,
                  style: Theme.of(context).textTheme.titleSmall,
                ).gapBottom(16),
                BlocBuilder<ToggleCubit, bool>(
                  bloc: _switchCubit..initialValue(true),
                  builder: (_, __) {
                    return AppSwitch(
                      value: selectedStatus,
                      enableEdit: docType != DocType.view,
                      showConfirmationDailog: false,
                      onTap: (bool val) {
                        selectedStatus = val;
                        _switchCubit.change();
                      },
                    );
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: _nameController..text = selectedName,
                      label: AppStrings.name,
                      readOnly: docType == DocType.view,
                    ).gapBottom(16.h),
                    AppTextField(
                      controller: _emailController..text = selectedEmail,
                      label: AppStrings.email,
                      readOnly: docType == DocType.view,
                    ),
                  ],
                ).flexible(),
                const VerticalDivider(color: Colors.black).paddingH(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BlocBuilder<IndexCubit, int>(
                      bloc: indexCubit,
                      builder: (context, state) {
                        return AppDropDown<int>(
                          value: selectedAdminLevel,
                          items: adminLevel,
                          prefixText: 'Admin Level ',
                          onChanged: (int? newValue) {
                            if (docType != DocType.view) {
                              selectedAdminLevel = newValue!;
                              _toggleCubit.change();
                            }
                          },
                        );
                      },
                    )
                  ],
                ).flexible()
              ],
            ).gapBottom(32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton.negative(
                  padding: paddingButton,
                  onTap: () => Navigator.pop(context),
                ),
                if (docType != DocType.view)
                  BlocBuilder<ToggleCubit, bool>(
                    bloc: _saveCubit,
                    builder: (_, __) {
                      return AppButton.positive(
                        isLoading: isLoading,
                        padding: paddingButton,
                        onTap: () async {
                          isLoading = true;
                          _saveCubit.change();

                          final name = _nameController.text.toString().trim();
                          final email = _emailController.text.toString().trim();
                          final adminLevel = selectedAdminLevel;
                          final active = selectedStatus;
                          if (admin != null) {
                            await _adminCubit.updateAdmin(
                              AdminModel(
                                id: admin!.id,
                                name: name,
                                email: email,
                                adminLevel: adminLevel,
                                active: selectedStatus,
                              ),
                            );
                          } else {
                            snackBar(context, 'Please fill the fields');
                          }

                          isLoading = false;
                          _saveCubit.change();
                        },
                      );
                    },
                  ).gapLeft(8.w),
              ],
            ).sizedBoxW(hfWidth),
          ],
        );
      },
    );
  }
}

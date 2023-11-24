import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/admins/admins_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/admin_model.dart';
import 'package:memee_admin/ui/__shared/enum/doc_type.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../../blocs/index/index_cubit.dart';
import '../../../../__shared/widgets/app_button.dart';
import '../../../../__shared/widgets/app_switch.dart';
import '../../../../__shared/widgets/dialog_header.dart';

class AdminDetailedWidget extends StatelessWidget {
  final AdminModel? admin;
  const AdminDetailedWidget({
    super.key,
    this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<AdminCubit>(),
      child: _AdminDetailed(admin: admin),
    );
  }
}

class _AdminDetailed extends StatefulWidget {
  final AdminModel? admin;

  const _AdminDetailed({
    required this.admin,
  });

  @override
  State<_AdminDetailed> createState() => _AdminDetailedState();
}

class _AdminDetailedState extends State<_AdminDetailed> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final List<int> adminLevel = [0, 1, 2];

  bool enableEdit = false;

  late AdminModel admin;
  late String selectedId = '';
  late String selectedName = '';
  late String selectedEmail = '';
  late bool selectedStatus = false;
  late int selectedAdminLevel = adminLevel[0];

  final indexCubit = locator.get<IndexCubit>();
  @override
  void initState() {
    super.initState();
    if (widget.admin != null) {
      admin = widget.admin!;
      _resetForm(admin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DialogHeader(
          label: AppStrings.admins,
          docType: DocType.add,
          onTap: () {
            setState(() {
              enableEdit = !enableEdit;
              if (!enableEdit) {
                _resetForm(admin);
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedId.isNotEmpty ? 'ID: ${admin.id}' : AppStrings.add,
              style: Theme.of(context).textTheme.titleSmall,
            ).gapBottom(16),
            AppSwitch(
              postiveLabel: AppStrings.active,
              negativeaLabel: AppStrings.disabled,
              value: selectedStatus,
              enableEdit: enableEdit,
              onTap: (value) {
                if (enableEdit) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
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
                  readOnly: !enableEdit,
                ).gapBottom(16.h),
                AppTextField(
                  controller: _emailController..text = selectedEmail,
                  label: AppStrings.email,
                  readOnly: !enableEdit,
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
                        if (enableEdit) {
                          selectedAdminLevel = newValue!;
                          indexCubit.onIndexChange(newValue);
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
              onTap: () => Navigator.pop(context),
            ),
            if (widget.admin == null || enableEdit)
              AppButton.positive(
                onTap: () {
                  if (widget.admin != null) {
                    admin.name = _nameController.text.toString().trim();
                    admin.email = _emailController.text.toString().trim();
                    admin.adminLevel = selectedAdminLevel;
                    admin.active = selectedStatus;
                    context.read<AdminCubit>().updateAdmin(admin);
                  } else {}
                  Navigator.pop(context, admin);
                },
              ).gapLeft(8.w),
          ],
        )
      ],
    );
  }

  _resetForm(AdminModel admin) {
    selectedId = admin.id;
    selectedName = admin.name;
    selectedEmail = admin.email;
    selectedAdminLevel = admin.adminLevel;
    selectedStatus = admin.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

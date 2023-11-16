import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/admins/admins_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/admin_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

class AdminDetailed extends StatelessWidget {
  final AdminModel? admin;
  const AdminDetailed({
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

  final List<num> adminLevel = [0, 1, 2];

  bool enableEdit = false;

  late AdminModel admin;
  late String selectedId = '';
  late String selectedName = '';
  late String selectedEmail = '';
  late bool selectedStatus = false;
  late num selectedAdminLevel = adminLevel[0];

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
    final size = MediaQuery.of(context).size;
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
            if (widget.admin != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    enableEdit = !enableEdit;
                    if (!enableEdit) {
                      _resetForm(admin);
                    }
                  });
                },
                icon: Icon(enableEdit ? Icons.clear : Icons.edit),
              ).gapLeft(8.w)
          ],
        ).gapBottom(32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedId.isNotEmpty ? 'ID: ${admin.id}' : AppStrings.add).gapBottom(16),
            SizedBox(
              width: size.width / 8,
              child: SwitchListTile(
                value: selectedStatus,
                onChanged: (value) {
                  if (enableEdit) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
                title: Text(
                  selectedStatus ? AppStrings.active : AppStrings.disabled,
                ),
              ),
            ),
          ],
        ),
        AppTextField(
          controller: _nameController..text = selectedName,
          label: AppStrings.name,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _emailController..text = selectedEmail,
          label: AppStrings.email,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        DropdownButton<num>(
          value: selectedAdminLevel,
          items: adminLevel
              .map(
                (num level) => DropdownMenuItem<num>(
                  value: level,
                  child: Text('Admin Level $level'),
                ),
              )
              .toList(),
          onChanged: (num? newValue) {
            if (enableEdit) {
              selectedAdminLevel = newValue!;
              setState(() {});
            }
          },
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              child: const Text(AppStrings.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            if (widget.admin == null || enableEdit)
              ElevatedButton(
                child: const Text(AppStrings.save),
                onPressed: () {
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

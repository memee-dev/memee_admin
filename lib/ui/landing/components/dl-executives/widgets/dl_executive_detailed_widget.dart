import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/dl_executive_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

class DLExecutiveDetailed extends StatelessWidget {
  final DlExecutiveModel? dlExecutive;

  const DLExecutiveDetailed({
    super.key,
    this.dlExecutive,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<DlExecutiveCubit>(),
      child: _DLExecutiveDetailed(dlExecutive: dlExecutive),
    );
  }
}

class _DLExecutiveDetailed extends StatefulWidget {
  final DlExecutiveModel? dlExecutive;

  const _DLExecutiveDetailed({
    required this.dlExecutive,
  });

  @override
  State<_DLExecutiveDetailed> createState() => _DLExecutiveDetailedState();
}

class _DLExecutiveDetailedState extends State<_DLExecutiveDetailed> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

  bool enableEdit = false;

  late DlExecutiveModel dlExecutive;
  late String selectedId = '';
  late String selectedName = '';
  late String selectedPhoneNumber = '';
  late String selectedEmail = '';
  late String selectedAadhar = '';
  late bool selectedStatus = false;
  late bool selectedAlloted = false;

  @override
  void initState() {
    super.initState();
    if (widget.dlExecutive != null) {
      dlExecutive = widget.dlExecutive!;
      _resetForm(dlExecutive);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.de,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            if (widget.dlExecutive != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    enableEdit = !enableEdit;
                    if (!enableEdit) {
                      _resetForm(dlExecutive);
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
            Text(
              selectedId.isNotEmpty ? 'ID: ${dlExecutive.id}' : AppStrings.add,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppSwitch(
              label: selectedStatus ? AppStrings.active : AppStrings.disabled,
              value: selectedStatus,
              enableEdit: enableEdit,
              showConfirmationDailog: false,
              onTap: (value) {
                if (enableEdit) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
          ],
        ).gapBottom(24.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTextField(
                  controller: _nameController..text = selectedName,
                  label: AppStrings.userName,
                  readOnly: !enableEdit,
                ).gapBottom(8.w),
                AppTextField(
                  controller: _phoneNumberController
                    ..text = selectedPhoneNumber,
                  label: AppStrings.phoneNumber,
                  readOnly: !enableEdit,
                ).gapBottom(8.w),
                AppTextField(
                  controller: _emailController..text = selectedEmail,
                  label: AppStrings.email,
                  readOnly: !enableEdit,
                ).gapBottom(8.w),
                AppTextField(
                  controller: _aadharController..text = selectedAadhar,
                  label: AppStrings.aadhar,
                  readOnly: !enableEdit,
                )
              ],
            ).flexible(),
            const VerticalDivider().paddingH(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.dl}: ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      dlExecutive.dlNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ).gapBottom(16.h),
                Image.network(
                  dlExecutive.dlUrl,
                ),
              ],
            ).flexible(),
          ],
        ).gapBottom(32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.negative(
              onTap: () => Navigator.pop(context),
            ),
            if (widget.dlExecutive == null || enableEdit)
              AppButton.positive(
                onTap: () {
                  dlExecutive.name = _nameController.text.toString().trim();
                  dlExecutive.phoneNumber =
                      _phoneNumberController.text.toString().trim();
                  dlExecutive.email = _emailController.text.toString().trim();
                  dlExecutive.aadhar = _aadharController.text.toString().trim();
                },
              ).gapLeft(8.w),
          ],
        )
      ],
    );
  }

  _resetForm(DlExecutiveModel dlExecutive) {
    selectedId = dlExecutive.id;
    selectedName = dlExecutive.name;
    selectedEmail = dlExecutive.email;
    selectedPhoneNumber = dlExecutive.phoneNumber;
    // selectedDlNumber = dlExecutive.dlNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

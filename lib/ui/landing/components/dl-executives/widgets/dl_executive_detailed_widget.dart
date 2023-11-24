import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _dlNumberController = TextEditingController();

  bool enableEdit = false;

  late DlExecutiveModel dlExecutive;
  late String selectedId = '';
  late String selectedName = '';
  late String selectedPhoneNumber = '';
  late String selectedEmail = '';
  late String selectedAadhar = '';
  late String selectedDlNumber = '';
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
    final _dlCubit = context.read<DlExecutiveCubit>();
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
              selectedId.isNotEmpty ? 'ID: $selectedId' : AppStrings.add,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppSwitch(
              postiveLabel: AppStrings.active,
              negativeaLabel: AppStrings.disabled,
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
                  controller: _phoneNumberController..text = selectedPhoneNumber,
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
            ).gapRight(4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppTextField(
                  controller: _dlNumberController..text = selectedDlNumber,
                  label: AppStrings.dlNo,
                  readOnly: !enableEdit,
                ).gapBottom(16.h),
                if (dlExecutive.dlUrl != null)
                  Image.network(
                    dlExecutive.dlUrl!,
                  ).gapBottom(16.h),
                if (widget.dlExecutive == null || enableEdit)
                  AppButton(
                    label: AppStrings.changeDL,
                    onTap: () async {
                      final image = await locator.get<ImagePicker>().pickImage(
                            source: ImageSource.gallery,
                          );
                      if (image != null) {
                        _dlCubit.updateDLImage(image);
                      }
                    },
                  )
              ],
            ),
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
                  final name = _nameController.text.toString().trim();
                  final phoneNumber = _phoneNumberController.text.toString().trim();
                  final email = _emailController.text.toString().trim();
                  final aadhar = _aadharController.text.toString().trim();
                  final dlNumber = _dlNumberController.text.toString().trim();

                  if (widget.dlExecutive == null) {
                    dlExecutive = DlExecutiveModel(
                      name: name,
                      email: email,
                      phoneNumber: phoneNumber,
                      dlNumber: dlNumber,
                      aadhar: aadhar,
                    );
                    _dlCubit.addDlExecutive(dlExecutive);
                  } else {
                    dlExecutive.name = _nameController.text.toString().trim();
                    dlExecutive.phoneNumber = _phoneNumberController.text.toString().trim();
                    dlExecutive.email = _emailController.text.toString().trim();
                    dlExecutive.aadhar = _aadharController.text.toString().trim();
                    dlExecutive.dlNumber = _dlNumberController.text.toString().trim();
                    _dlCubit.updateDlExecutive(dlExecutive);
                  }
                },
              ).gapLeft(8.w),
          ],
        )
      ],
    );
  }

  _resetForm(DlExecutiveModel dlExecutive) {
    selectedId = dlExecutive.id!;
    selectedName = dlExecutive.name;
    selectedEmail = dlExecutive.email;
    selectedPhoneNumber = dlExecutive.phoneNumber;
    selectedAadhar = dlExecutive.aadhar!;
    selectedDlNumber = dlExecutive.dlNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _aadharController.dispose();
    _dlNumberController.dispose();
    super.dispose();
  }
}

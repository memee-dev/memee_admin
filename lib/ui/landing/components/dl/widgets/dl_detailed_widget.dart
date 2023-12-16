import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/dl_executive_model.dart';
import 'package:memee_admin/ui/__shared/enum/doc_type.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../../blocs/toggle/toggle_cubit.dart';
import '../../../../__shared/widgets/utils.dart';

class DLDetailed extends StatelessWidget {
  final DlExecutiveModel? dlExecutive;

  const DLDetailed({
    super.key,
    this.dlExecutive,
  });

  @override
  Widget build(BuildContext context) {
    final _dlCubit = locator.get<DlExecutiveCubit>();
    final _toggleCubit = locator.get<RefreshCubit>();
    final _activeCubit = locator.get<RefreshCubit>();
    final _allotedCubit = locator.get<RefreshCubit>();
    final _saveCubit = locator.get<RefreshCubit>();

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneNumberController =
        TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _aadharController = TextEditingController();
    final TextEditingController _dlNumberController = TextEditingController();

    late String selectedName = '';
    late String selectedPhoneNumber = '';
    late String selectedEmail = '';
    late String selectedAadhar = '';
    late String selectedDlNumber = '';
    late bool selectedStatus = false;
    late bool selectedAlloted = false;

    DocType docType = getDocType<DlExecutiveModel>(dlExecutive, false);

    _resetForm() {
      if (dlExecutive != null) {
        selectedName = dlExecutive!.name;
        selectedEmail = dlExecutive!.email;
        selectedPhoneNumber = dlExecutive!.phoneNumber;
        selectedAadhar = dlExecutive!.aadhar!;
        selectedDlNumber = dlExecutive!.dlNumber;
      }
    }

    _resetForm();

    return BlocBuilder<RefreshCubit, bool>(
      bloc: _toggleCubit,
      builder: (_, state) {
        double hfWidth = 175.w;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.dlExecutive,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    if ((docType != DocType.add))
                      IconButton(
                        onPressed: () {
                          docType = getDocType<DlExecutiveModel>(
                              dlExecutive, docType != DocType.edit);
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
                      (docType != DocType.add) ? 'ID: ${dlExecutive!.id}' : '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        BlocBuilder<RefreshCubit, bool>(
                          bloc: _allotedCubit..initialValue(true),
                          builder: (_, __) {
                            return AppSwitch(
                              positiveLabel: AppStrings.allot,
                              value: selectedAlloted,
                              enableEdit: docType != DocType.view,
                              showConfirmationDialog: false,
                              onTap: (bool val) {
                                selectedAlloted = val;
                                _allotedCubit.change();
                              },
                            );
                          },
                        ).gapRight(16.w),
                        BlocBuilder<RefreshCubit, bool>(
                          bloc: _activeCubit..initialValue(true),
                          builder: (_, __) {
                            return AppSwitch(
                              positiveLabel: AppStrings.active,
                              value: selectedStatus,
                              enableEdit: docType != DocType.view,
                              showConfirmationDialog: false,
                              onTap: (bool val) {
                                selectedStatus = val;
                                _activeCubit.change();
                              },
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ).sizedBoxW(hfWidth).gapBottom(12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextField(
                          controller: _nameController..text = selectedName,
                          label: AppStrings.userName,
                          readOnly: docType == DocType.view,
                        ).gapBottom(8.w),
                        AppTextField(
                          controller: _phoneNumberController
                            ..text = selectedPhoneNumber,
                          label: AppStrings.phoneNumber,
                          readOnly: docType == DocType.view,
                        ).gapBottom(8.w),
                        AppTextField(
                          controller: _emailController..text = selectedEmail,
                          label: AppStrings.email,
                          readOnly: docType == DocType.view,
                        ).gapBottom(8.w),
                        AppTextField(
                          controller: _aadharController..text = selectedAadhar,
                          label: AppStrings.aadhar,
                          readOnly: docType == DocType.view,
                        )
                      ],
                    ).gapRight(4.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: _dlNumberController
                            ..text = selectedDlNumber,
                          label: AppStrings.dlNo,
                          readOnly: docType == DocType.view,
                        ).gapBottom(16.h),
                        if (docType != DocType.add &&
                            dlExecutive!.dlUrl != null)
                          Image.network(
                            dlExecutive!.dlUrl!,
                          ).gapBottom(16.h),
                        if (docType != DocType.view)
                          AppButton(
                            label: AppStrings.changeDL,
                            onTap: () async {
                              final image =
                                  await locator.get<ImagePicker>().pickImage(
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
                    AppButton.secondary(
                      label: AppStrings.cancel,
                      onTap: () => Navigator.pop(context),
                    ),
                    if (docType != DocType.view)
                      BlocBuilder<RefreshCubit, bool>(
                        bloc: _saveCubit,
                        builder: (_, __) {
                          return AppButton.primary(
                            label: AppStrings.save,
                            onTap: () async {
                              _saveCubit.change();

                              final name =
                                  _nameController.text.toString().trim();
                              final email =
                                  _emailController.text.toString().trim();
                              final aadhar =
                                  _aadharController.text.toString().trim();
                              final phoneNumber =
                                  _phoneNumberController.text.toString().trim();
                              final dlNumber =
                                  _dlNumberController.text.toString().trim();
                              if (name.isNotEmpty &&
                                  phoneNumber.isNotEmpty &&
                                  email.isNotEmpty &&
                                  aadhar.isNotEmpty &&
                                  dlNumber.isNotEmpty) {
                                if (docType == DocType.add) {
                                  _dlCubit.addDlExecutive(
                                      name: name,
                                      phoneNumber: phoneNumber,
                                      email: email,
                                      aadhar: aadhar,
                                      dlNumber: dlNumber,
                                      active: selectedStatus,
                                      alloted: selectedAlloted);
                                } else {
                                  if (dlExecutive != null) {
                                    await _dlCubit.updateDlExecutive(
                                      DlExecutiveModel(
                                        id: dlExecutive!.id,
                                        name: name,
                                        phoneNumber: phoneNumber,
                                        email: email,
                                        aadhar: aadhar,
                                        dlNumber: dlNumber,
                                        active: selectedStatus,
                                        alloted: selectedAlloted,
                                      ),
                                    );
                                  }
                                }

                                Navigator.pop(context);
                              } else {
                                snackBar(context, 'Please fill the fields');
                              }
                              _saveCubit.change();
                            },
                          );
                        },
                      ).gapLeft(8.w),
                  ],
                ).sizedBoxW(hfWidth),
              ],
            ),
          ],
        );
      },
    );
  }
}

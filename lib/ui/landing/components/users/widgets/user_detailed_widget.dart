import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/index/index_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/enum/doc_type.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../../blocs/users/users_cubit.dart';
import '../../../../../models/user_model.dart';
import '../../../../__shared/widgets/app_dropdown.dart';
import '../../../../__shared/widgets/dialog_header.dart';
import 'show_address_widget.dart';

class UserDetailed extends StatelessWidget {
  final UserModel? user;

  const UserDetailed({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<UserCubit>(),
      child: _UserDetailed(user: user),
    );
  }
}

class _UserDetailed extends StatefulWidget {
  final UserModel? user;

  const _UserDetailed({
    required this.user,
  });

  @override
  State<_UserDetailed> createState() => _UserDetailedState();
}

class _UserDetailedState extends State<_UserDetailed> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool enableEdit = false;

  late UserModel user;
  late String selectedId = '';
  late String selectedUserName = '';
  late String selectedPhoneNumber = '';
  late String selectedEmail = '';
  late String selectedArea = '';
  late String selectedPincode = '';
  late String selectedNo = '';
  late String selectedCity = '';
  late String selectedStreet = '';
  late String selectedLandmark = '';
  late String selectedType = '';
  late bool selectedStatus = false;
  late bool selectedVerified = false;

  AddressModel? selectedAddress;

  final showAddressIndexCubit = locator.get<IndexCubit>();
  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      user = widget.user!;
      _resetForm(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userCubit = context.read<UserCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DialogHeader(
          label: AppStrings.user,
          docType: DocType.add,
          onTap: () {
            setState(() {
              enableEdit = !enableEdit;
              if (!enableEdit) {
                _resetForm(user);
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedId.isNotEmpty ? 'ID: ${user.id}' : AppStrings.add,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                AppSwitch(
                  positiveLabel: AppStrings.verified,
                  negativeLabel: AppStrings.notVerified,
                  value: selectedVerified,
                  enableEdit: enableEdit,
                  onTap: (value) {
                    if (enableEdit) {
                      setState(() {
                        selectedVerified = value;
                      });
                    }
                  },
                ),
                SizedBox(width: 16.w),
                AppSwitch(
                  positiveLabel: AppStrings.active,
                  negativeLabel: AppStrings.disabled,
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
          ],
        ).gapBottom(24.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTextField(
                  controller: _userNameController..text = selectedUserName,
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
                )
              ],
            ).flexible(),
            const VerticalDivider(color: Colors.black).paddingH(),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(AppStrings.addresses),
                    Row(
                      children: [
                        if (selectedAddress != null)
                          BlocBuilder<IndexCubit, int>(
                            bloc: showAddressIndexCubit,
                            builder: (_, state) {
                              return AppDropDown<AddressModel>(
                                value: selectedAddress!,
                                items: user.address,
                                onChanged: (AddressModel? val) {
                                  if (val != null) {
                                    selectedAddress = val;
                                    showAddressIndexCubit.onIndexChange(
                                      user.address.indexOf(val),
                                    );
                                  }
                                },
                              );
                            },
                          ).gapRight(8.w),
                        FloatingActionButton(
                          onPressed: () {
                            //code here for add address
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ).gapBottom(16.h),
                BlocBuilder<IndexCubit, int>(
                  bloc: showAddressIndexCubit,
                  builder: (_, state) {
                    return ShowAddress(
                      address: selectedAddress!,
                      enableEdit: enableEdit,
                    );
                  },
                ),
              ],
            ).flexible(),
          ],
        ).gapBottom(32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.secondary(
              label: AppStrings.cancel,
              onTap: () => Navigator.pop(context),
            ),
            if (widget.user == null || enableEdit)
              AppButton.primary(
                label: AppStrings.save,
                onTap: () {
                  user.userName = _userNameController.text.toString().trim();
                  user.phoneNumber =
                      _phoneNumberController.text.toString().trim();
                  user.email = _emailController.text.toString().trim();
                  user.active = selectedStatus;
                  user.verified = selectedVerified;
                  if (widget.user != null) {
                    _userCubit.updateUser(user);
                  } else {
                    _userCubit.addUser(user);
                  }
                  Navigator.pop(context, user);
                },
              ).gapLeft(8.w),
          ],
        )
      ],
    );
  }

  _resetForm(UserModel user) {
    selectedId = user.id;
    selectedUserName = user.userName;
    selectedEmail = user.email;
    selectedPhoneNumber = user.phoneNumber;
    selectedAddress = user.address.first;
    selectedStatus = user.active;
    selectedVerified = user.verified;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

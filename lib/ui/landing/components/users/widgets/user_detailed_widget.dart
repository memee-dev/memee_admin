import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/index/index_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../../blocs/users/users_cubit.dart';
import '../../../../../models/user_model.dart';
import '../../../../__shared/widgets/app_dropdown.dart';
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

  final showAddresIndexCubit = locator.get<IndexCubit>();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.user,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            if (widget.user != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    enableEdit = !enableEdit;
                    if (!enableEdit) {
                      _resetForm(user);
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
              selectedId.isNotEmpty ? 'ID: ${user.id}' : AppStrings.add,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                AppSwitch(
                  postiveLabel: AppStrings.verified,
                  negativeaLabel: AppStrings.notVerified,
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
                            bloc: showAddresIndexCubit,
                            builder: (_, state) {
                              return AppDropDown<AddressModel>(
                                value: selectedAddress!,
                                items: user.address,
                                onChanged: (AddressModel? val) {
                                  if (val != null) {
                                    selectedAddress = val;
                                    showAddresIndexCubit.onIndexChange(
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
                  bloc: showAddresIndexCubit,
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
            AppButton.negative(
              onTap: () => Navigator.pop(context),
            ),
            if (widget.user == null || enableEdit)
              AppButton.positive(
                onTap: () {
                  user.userName = _userNameController.text.toString().trim();
                  user.phoneNumber =
                      _phoneNumberController.text.toString().trim();
                  user.email = _emailController.text.toString().trim();
                  user.active = selectedStatus;
                  user.verified = selectedVerified;
                  if (widget.user != null) {
                    context.read<UserCubit>().updateUser(user);
                  } else {
                    context.read<UserCubit>().addUser(user);
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

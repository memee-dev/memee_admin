import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../blocs/users/users_cubit.dart';
import '../../../models/user_model.dart';

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
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

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
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.users,
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
            Text(selectedId.isNotEmpty
                ? 'ID: ${user.userName}'
                : AppStrings.add)
                .gapBottom(16),
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
          controller: _userNameController..text = selectedUserName,
          label: AppStrings.userName,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _phoneNumberController..text = selectedPhoneNumber,
          label: AppStrings.phoneNumber,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _emailController..text = selectedEmail,
          label: AppStrings.email,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        Text(selectedId.isNotEmpty
            ? 'ID: ${user.userName}'
            : AppStrings.address)
            .gapBottom(16),
        AppTextField(
          controller: _areaController..text = selectedArea,
          label: AppStrings.area,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _pincodeController..text = selectedPincode,
          label: AppStrings.pinCode,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _noController..text = selectedNo,
          label: AppStrings.no,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _streetController..text = selectedStreet,
          label: AppStrings.street,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _landmarkController..text = selectedLandmark,
          label: AppStrings.landmark,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _typeController..text = selectedType,
          label: AppStrings.type,
          readOnly: !enableEdit,
        ).gapBottom(16.h),
        AppTextField(
          controller: _cityController..text = selectedCity,
          label: AppStrings.city,
          readOnly: !enableEdit,
        ).gapBottom(16.h),

        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              child: const Text(AppStrings.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            if (widget.user == null || enableEdit)
              ElevatedButton(
                child: const Text(AppStrings.save),
                onPressed: () {
                  if (widget.user != null) {
                    user.userName = _userNameController.text.toString().trim();
                    user.phoneNumber =
                        _phoneNumberController.text.toString().trim();
                    user.email = _emailController.text.toString().trim();
                    address.area = _areaController.text.toString().trim();
                    address.pincode = _pincodeController.text.toString().trim();
                    address.no = _noController.text.toString().trim();
                    address.street = _streetController.text.toString().trim();
                    address.landmark =
                        _landmarkController.text.toString().trim();
                    address.type = _typeController.text.toString().trim();
                    address.city = _cityController.text.toString().trim();
                    user.active = selectedStatus;
                    user.verified = selectedVerified;
                    context.read<UserCubit>().updateUser(user);
                  } else {}
                  Navigator.pop(context, user);
                },
              ).gapLeft(8.w),
          ],
        )
      ],
    );
  }

  _resetForm(UserModel user) {
    // selectedId = user.id;
    selectedUserName = user.userName;
    selectedEmail = user.email;
    selectedPhoneNumber = user.phoneNumber;
    selectedArea = address.area;
    selectedPincode = address.pincode;
    selectedCity = address.city;
    selectedNo = address.no;
    selectedStreet = address.street;
    selectedLandmark = address.landmark;
    selectedType = address.type;
    selectedStatus = user.active;
    selectedVerified = user.verified;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _noController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _typeController.dispose();

    super.dispose();
  }
}

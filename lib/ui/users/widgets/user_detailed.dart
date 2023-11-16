import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/admins/admins_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/admin_model.dart';
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
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final List<num> userLevel = [0, 1, 2];

  bool enableEdit = false;

  late UserModel user;
  late String selectedId = '';
  late String selectedName = '';
  late String selectedEmail = '';
  late bool selectedStatus = false;



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
    return SizedBox(
      width: size.width / 2,
      height: size.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.admins,
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
              Text(selectedId.isNotEmpty ? 'ID: ${user.userName}' : AppStrings.add).gapBottom(16),
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
                      user.userName = _nameController.text.toString().trim();
                      user.email = _emailController.text.toString().trim();
                     // user.phoneNumber = selectedPhoneNumber;
                      user.active = selectedStatus;
                      context.read<UserCubit>().updateUser(user);
                    } else {}
                    Navigator.pop(context, user);
                  },
                ).gapLeft(8.w),
            ],
          )
        ],
      ),
    );
  }

  _resetForm(UserModel user) {
    //selectedId = user.id;
    selectedName = user.userName;
    selectedEmail = user.email;
    //selectedPhoneNumber = user.phoneNumber;
    selectedStatus = user.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../../blocs/hide_and_seek/hide_and_seek_cubit.dart';
import '../../blocs/login/login_cubit.dart';
import '../../core/initializer/app_di_registration.dart';
import '../../core/shared/app_strings.dart';
import '../__shared/widgets/app_button.dart';
import '../__shared/widgets/app_textfield.dart';
import '../__shared/widgets/utils.dart';

class LoginPageMob extends StatelessWidget {
  final TextEditingController _emailController =
      TextEditingController(text: kDebugMode ? 'admin@memee.com' : '');
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? '123456' : '');
  final HideAndSeekCubit hideAndSeekCubit = locator.get<HideAndSeekCubit>();

  LoginPageMob({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppTextField(
          controller: _emailController,
          label: AppStrings.email,
        ).gapBottom(8.h),
        BlocBuilder<HideAndSeekCubit, bool>(
          bloc: hideAndSeekCubit,
          builder: (_, state) {
            return AppTextField(
              controller: _passwordController,
              label: AppStrings.password,
              obscureText: state,
              suffixIcon: IconButton(
                onPressed: () => hideAndSeekCubit.change(),
                icon: Icon(!state ? Icons.visibility : Icons.visibility_off),
              ),
            );
          },
        ).gapBottom(16.h),
        BlocConsumer<LoginCubit, LoginStatus>(
          listener: (_, state) {
            if (state == LoginStatus.initial) {
              _emailController.text = '';
              _passwordController.text = '';
            }
            if (state == LoginStatus.failure) {
              snackBar(context, 'Login Error');
            }
          },
          builder: (_, state) {
            bool isLoading = false;
            if (state == LoginStatus.loading) {
              isLoading = true;
            }

            return AppButton(
              isLoading: isLoading,
              label: AppStrings.login,
              onTap: () => locator.get<LoginCubit>().loginWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
            );
          },
        )
      ],
    ).paddingS();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/template/app_layout.dart';
import 'package:memee_admin/ui/login/login_page_mob.dart';
import '../../blocs/hide_and_seek/hide_and_seek_cubit.dart';
import '../../blocs/login/login_cubit.dart';
import '../../core/initializer/app_di.dart';
import '../../core/shared/app_strings.dart';
import '../__shared/widgets/app_button.dart';
import '../__shared/widgets/app_textfield.dart';
import '../__shared/widgets/utils.dart';
import 'login_page_web.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  AppLayout(
      mobView: LoginPageMob(),
      webView:  const LoginPageWeb(),
    );
  }
}

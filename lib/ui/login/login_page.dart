import 'package:flutter/material.dart';
import 'package:memee_admin/ui/__shared/template/app_layout.dart';
import 'package:memee_admin/ui/login/login_page_mob.dart';
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

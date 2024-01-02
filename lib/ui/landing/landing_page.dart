import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/login/login_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/ui/__shared/template/app_layout.dart';

import '../../core/shared/app_strings.dart';
import 'landing_page_mob.dart';
import 'landing_page_web.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      webAppBar: AppBar(
        centerTitle: false,
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              locator<LoginCubit>().reset();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      mobView: const LandingPageMob(),
      webView: LandingPageWeb(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/login/login_cubit.dart';
import 'package:memee_admin/blocs/users/users_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/ui/__shared/template/app_layout.dart';

import 'landing_page_mob.dart';
import 'landing_page_web.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserCubit>().fetchUsers();
    return AppLayout(
      webAppBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              locator<LoginCubit>().reset();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      mobView: const LandingPageMob(),
      webView: LandingPageWeb(),
    );
  }
}

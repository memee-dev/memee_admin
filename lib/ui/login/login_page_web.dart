import 'package:flutter/material.dart';

import 'login_page_mob.dart';

class LoginPageWeb extends StatelessWidget {
  const LoginPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: LoginPageMob(),
        )
      ],
    );
  }
}

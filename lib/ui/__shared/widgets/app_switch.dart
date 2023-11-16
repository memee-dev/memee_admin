import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/hide_and_seek/hide_and_seek_cubit.dart';
import '../../../core/initializer/app_di_registration.dart';
import '../../../core/shared/app_strings.dart';
import '../dialog/confirmation_dialog.dart';

class AppSwitch extends StatelessWidget {
  final bool status;
  final Function(bool) onTap;

  const AppSwitch({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = locator.get<HideAndSeekCubit>();
    return BlocBuilder<HideAndSeekCubit, bool>(
      bloc: cubit..initialValue(status),
      builder: (context, state) {
        return Switch(
          value: state,
          onChanged: (value) async {
            await showConfirmationDialog(
              context,
              onTap: (bool val) {
                Navigator.pop(context);
                if (val) {
                  cubit.change();
                  onTap(!state);
                }
              },
            );
          },

        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../../../blocs/toggle/toggle_cubit.dart';
import '../../../core/initializer/app_di_registration.dart';
import '../dialog/confirmation_dialog.dart';

class AppSwitch extends StatelessWidget {
  final String? postiveLabel;
  final String? negativeaLabel;
  final bool value;
  final Function(bool) onTap;
  final bool enableEdit;
  final bool showConfirmationDailog;

  const AppSwitch({
    super.key,
    required this.value,
    this.postiveLabel,
    this.negativeaLabel,
    required this.onTap,
    this.enableEdit = true,
    this.showConfirmationDailog = true,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = locator.get<ToggleCubit>();
    return BlocBuilder<ToggleCubit, bool>(
      bloc: cubit..initialValue(value),
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (postiveLabel != null && negativeaLabel != null)
              Text((value ? postiveLabel : negativeaLabel)!).gapRight(4.w)
            else if (postiveLabel != null)
              Text((postiveLabel)!).gapRight(4.w)
            else if (negativeaLabel != null)
              Text((negativeaLabel)!).gapRight(4.w),
            Switch(
              value: state,
              onChanged: (value) async {
                if (enableEdit) {
                  if (showConfirmationDailog) {
                    await showConfirmationDialog(
                      context,
                      onTap: (bool val) {
                        Navigator.pop(context);
                        if (val) {
                          _setSwitch(cubit, state);
                        }
                      },
                    );
                  } else {
                    cubit.change();
                    onTap(!state);
                    _setSwitch(cubit, state);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _setSwitch(ToggleCubit cubit, bool state) {
    cubit.change();
    onTap(!state);
  }
}

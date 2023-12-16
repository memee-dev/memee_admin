import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../../../blocs/toggle/toggle_cubit.dart';
import '../../../core/initializer/app_di_registration.dart';

class AppSwitch extends StatelessWidget {
  final String? positiveLabel;
  final String? negativeLabel;
  final bool value;
  final Function(bool) onTap;
  final bool enableEdit;
  final bool showConfirmationDialog;

  const AppSwitch({
    super.key,
    required this.value,
    this.positiveLabel,
    this.negativeLabel,
    required this.onTap,
    this.enableEdit = true,
    this.showConfirmationDialog = true,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = locator.get<RefreshCubit>();
    return BlocBuilder<RefreshCubit, bool>(
      bloc: cubit..initialValue(value),
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (positiveLabel != null && negativeLabel != null)
              Text((value ? positiveLabel : negativeLabel)!).gapRight(4.w)
            else if (positiveLabel != null)
              Text((positiveLabel)!).gapRight(4.w)
            else if (negativeLabel != null)
              Text((negativeLabel)!).gapRight(4.w),
            Switch(
              value: state,
              onChanged: (value) async {
                if (enableEdit) {
                  if (showConfirmationDialog) {
                    showConfirmationDialog;
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

  void _setSwitch(RefreshCubit cubit, bool state) {
    cubit.change();
    onTap(!state);
  }
}

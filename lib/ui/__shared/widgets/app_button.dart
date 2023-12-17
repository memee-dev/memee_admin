import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/toggle/toggle_cubit.dart';
import '../../../core/initializer/app_di_registration.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Color color;
  final Color textColor;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.amber,
    this.textColor = Colors.black,
    this.width,
    this.height,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.amber,
    this.textColor = Colors.black,
    this.width,
    this.height,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.black87,
    this.textColor = Colors.amberAccent,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final refreshCubit = locator.get<RefreshCubit>();
    bool loading = false;
    return BlocBuilder<RefreshCubit, bool>(
      bloc: refreshCubit,
      builder: (_, state) {
        return SizedBox(
          width: width ?? 28.w,
          height: height ?? 40.h,
          child: ElevatedButton(
            onPressed: () async {
              if (!loading) {
                loading = true;
                refreshCubit.change();
                await onTap();
                loading = false;
                refreshCubit.change();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator.adaptive()
                : Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textColor,
                        ),
                  ),
          ),
        );
      },
    );
  }
}

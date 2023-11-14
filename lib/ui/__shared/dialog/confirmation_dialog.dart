import 'package:flutter/material.dart';
import 'package:memee_admin/core/shared/app_strings.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, {
  required onTap(bool v),
}) async {
  return await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text(AppStrings.alert),
        content: const Text(AppStrings.areYouSure),
        actions: [
          ElevatedButton(
            child: const Text(AppStrings.cancel),
            onPressed: () => onTap(false),
          ),
          ElevatedButton(
            child: const Text(AppStrings.continuee),
            onPressed: () => onTap(true),
          ),
        ],
      );
    },
  );
}

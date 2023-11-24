import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

class DialogHeader extends StatelessWidget {
  final String label;
  final bool newItem;
  final bool enableEdit;
  final Function() onTap;
  const DialogHeader({
    super.key,
    required this.label,
    required this.newItem,
    required this.enableEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        if (!newItem)
          IconButton(
            onPressed: onTap,
            icon: Icon(enableEdit ? Icons.clear : Icons.edit),
          ).gapLeft(8.w)
      ],
    ).gapBottom(32);
  }
}

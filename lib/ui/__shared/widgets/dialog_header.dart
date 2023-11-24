import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../enum/doc_type.dart';

class DialogHeader extends StatelessWidget {
  final String label;
  final DocType docType;
  final Function() onTap;
  const DialogHeader({
    super.key,
    required this.label,
    required this.docType,
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
        if (docType != DocType.add)
          IconButton(
            onPressed: onTap,
            icon: Icon(docType == DocType.edit ? Icons.clear : Icons.edit),
          ).gapLeft(8.w)
      ],
    ).gapBottom(32);
  }
}

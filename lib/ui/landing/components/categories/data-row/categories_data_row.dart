import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../__shared/widgets/app_switch.dart';

DataRow categoryDataRow(
  BuildContext context, {
  required CategoryModel category,
  required Function() onDelete,
  required Function() onEdit,
}) {
  return DataRow(
    cells: [
      DataCell(Text(category.id)),
      DataCell(Text(category.name)),
      DataCell(
        AppSwitch(
          value: category.active,
          onTap: (bool val) {
            category.active = val;
            locator.get<CategoriesCubit>().updateCategory(category);
          },
        ),
      ),
      DataCell(Row(
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ).gapRight(4.w),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_forever_outlined),
          )
        ],
      ))
    ],
  );
}

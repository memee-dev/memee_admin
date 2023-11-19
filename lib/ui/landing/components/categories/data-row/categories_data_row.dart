import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/models/category_model.dart';

import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../__shared/widgets/app_switch.dart';

DataRow categoryDataRow(
  BuildContext context,
  CategoryModel category,
) {
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
    ],
  );
}

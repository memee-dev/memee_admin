import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';

DataRow product2DataRow(
   BuildContext context, {
  required ProductModel product,
  required Function() onDelete,
  required Function(bool?)? onSelectChanged,
}
) {
  return DataRow(
    cells: [
      DataCell(Text(product.id)),
      DataCell(Text(product.name)),
      DataCell(
        AppSwitch(
          value: product.active,
          onTap: (bool val) {
            product.active = val;
            locator.get<ProductsCubit>().updateProducts(product);
          },
        ),
      ),
    ],
    onSelectChanged: onSelectChanged
  );
}

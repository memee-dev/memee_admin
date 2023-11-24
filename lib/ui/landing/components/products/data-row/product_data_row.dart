import 'package:flutter/material.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/landing/components/dl-executives/widgets/dl_executive_detailed_widget.dart';
import 'package:memee_admin/ui/landing/components/products/widgets/view_edit_product_widget.dart';
import '../../../../__shared/dialog/detailed_dialog.dart';

DataRow productDataRow(
  BuildContext context,
  ProductModel product,
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
    onSelectChanged: (selected) async {
      final result = await showDetailedDialog(
        context,
        child: ViewEditProductWidget(product: product),
      );
      if (result != null && result is ProductModel) {
        product = result;
      }
    },
  );
}
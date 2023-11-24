import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _priceController = TextEditingController();
    final _dPriceController = TextEditingController();
    final _qtyController = TextEditingController();
    ProductType _selectedType = ProductType.kg;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField.decimals(
          controller: _priceController,
          label: AppStrings.price,
        ).gapBottom(8.h),
        AppTextField.decimals(
          controller: _dPriceController,
          label: AppStrings.discountedPrice,
        ).gapBottom(8.h),
        AppTextField.digits(
          controller: _qtyController,
          label: AppStrings.qty,
        ).gapBottom(8.h),
        AppDropDown<ProductType>(
          value: _selectedType,
          items: ProductType.values,
          onChanged: (val) {
            if (val != null) {
              _selectedType == val;
            }
          },
        ).gapBottom(32.h),
        Row(
          children: [
            AppButton.negative(onTap: () => Navigator.pop(context))
                .gapRight(8.w),
            AppButton.positive(onTap: () {
              String price = _priceController.text.trim();
              String dPrice = _dPriceController.text.trim();
              String qty = _qtyController.text.trim();
              if (price.isNotEmpty && dPrice.isNotEmpty && qty.isNotEmpty) {
                Navigator.pop(
                  context,
                  ProductDetailsModel(
                    price: double.parse(price),
                    discountedPrice: double.parse(dPrice),
                    qty: int.parse(qty),
                    type: _selectedType,
                  ),
                );
              }
            }),
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../__shared/enum/doc_type.dart';

class ProductDetailWidget extends StatelessWidget {
  final ProductDetailsModel? productDetails;
  const ProductDetailWidget({
    super.key,
    required this.productDetails,
  });

  @override
  Widget build(BuildContext context) {
    
    final _priceController = TextEditingController();
    final _dPriceController = TextEditingController();
    final _qtyController = TextEditingController();
    ProductType selectedType = ProductType.kg;

    late double selectedPrice ;
    late double selectedDprice  ;
    late double selectedQty  ;
    

    DocType docType = getDocType<ProductDetailsModel>(productDetails, false);
    _resetForm() {
      if (productDetails != null) {
        selectedPrice = productDetails!.price;
        selectedDprice = productDetails!.discountedPrice;
        selectedQty = productDetails!.qty ;
        selectedType = productDetails!.type;
       
      }
    }

    _resetForm();

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
          value: selectedType,
          items: ProductType.values,
          onChanged: (val) {
            if (val != null) {
              selectedType == val;
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
                    qty: double.parse(qty),
                    type: selectedType,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../../blocs/toggle/toggle_cubit.dart';
import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../__shared/enum/doc_type.dart';

class DetailDialogWidget extends StatelessWidget {
  final ProductDetailsModel? productDetails;
  const DetailDialogWidget({super.key, this.productDetails});

  @override
  Widget build(BuildContext context) {
    DocType docType = getDocType<ProductDetailsModel>(productDetails, false);

    final _refreshCubit = locator.get<ToggleCubit>();
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
        BlocBuilder<ToggleCubit, bool>(
          bloc: _refreshCubit..initialValue(true),
          builder: (_, state) {
            return AppDropDown<ProductType>(
              value: _selectedType,
              items: ProductType.values,
              onChanged: (ProductType? val) {
                if (docType != DocType.view && val != null) {
                  _selectedType = val;
                  _refreshCubit.change();
                }
              },
            );
          },
        ).gapBottom(32.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/blocs/toggle/toggle_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../__shared/enum/doc_type.dart';
import '../../../../__shared/widgets/app_button.dart';

class Products2DetailedWidget extends StatelessWidget {
  final ProductModel? product;

  const Products2DetailedWidget({
    super.key,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    final _productCubit = locator.get<ProductsCubit>();
    final _toggleCubit = locator.get<ToggleCubit>();
    final _switchCubit = locator.get<ToggleCubit>();
    ProductType _selectedType = ProductType.kg;
    final _saveCubit = locator.get<ToggleCubit>();

    final _descriptionController = TextEditingController();
    final _nameController = TextEditingController();

    late String selectedName = '';
    late String selectedDescription = '';
    late bool selectedStatus = true;
    late bool isLoading = false;

    DocType docType = getDocType<ProductModel>(product, false);

    _resetForm() {
      if (product != null) {
        selectedName = product!.name;
        selectedDescription = product!.description;
        selectedStatus = product!.active;
      }
    }

    _resetForm();

    final paddingButton = EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h);
    return BlocBuilder<ToggleCubit, bool>(
      bloc: _toggleCubit,
      builder: (_, state) {
        double hfWidth = 75.w;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.category,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    if ((docType != DocType.add))
                      IconButton(
                        onPressed: () {
                          docType = getDocType<ProductModel>(product, docType != DocType.edit);
                          _toggleCubit.change();
                        },
                        icon: Icon(
                          docType == DocType.edit ? Icons.close_outlined : Icons.edit_outlined,
                        ),
                      ),
                  ],
                ).sizedBoxW(hfWidth).gapBottom(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (docType != DocType.add) ? 'ID: ${product!.id}' : '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    BlocBuilder<ToggleCubit, bool>(
                      bloc: _switchCubit..initialValue(true),
                      builder: (_, __) {
                        return AppSwitch(
                          value: selectedStatus,
                          enableEdit: docType != DocType.view,
                          showConfirmationDailog: false,
                          onTap: (bool val) {
                            selectedStatus = val;
                            _switchCubit.change();
                          },
                        );
                      },
                    )
                  ],
                ).sizedBoxW(hfWidth).gapBottom(12.h),
                AppTextField(
                  readOnly: docType == DocType.view,
                  controller: _nameController..text = selectedName,
                  label: AppStrings.name,
                ).gapBottom(8.h),
                AppTextField(
                  readOnly: docType == DocType.view,
                  controller: _descriptionController..text = selectedDescription,
                  label: AppStrings.image,
                ).gapBottom(32.h),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton.negative(
                      padding: paddingButton,
                      onTap: () => Navigator.pop(context),
                    ),
                    if (docType != DocType.view)
                      BlocBuilder<ToggleCubit, bool>(
                          bloc: _saveCubit,
                          builder: (_, __) {
                            return Container();
                            // AppButton.positive(
                            //     isLoading: isLoading,
                            //     padding: paddingButton,
                            //     onTap: () async {
                            //       isLoading = true;
                            //       _saveCubit.change();

                            //       final name = _nameController.text.trim();
                            //       final description = _descriptionController.text.trim();
                            //       if (name.isNotEmpty && description.isNotEmpty) {
                            //         if (docType == DocType.add) {
                            //           _productCubit.addProduct(

                            //             description,
                            //             selectedStatus,
                            //           );
                            //         // } else {
                            //         //   if (product != null) {
                            //         //     await _productCubit.updateProducts(
                            //         //       ProductModel(
                            //         //         id: product!.id,
                            //         //         name: name,
                            //         //         category: ,
                            //         //         description: description,
                            //         //         active: selectedStatus,
                            //         //       ),
                            //         //     );
                            //         //   }
                            //         // }

                            //         Navigator.pop(context);
                            //       } else {
                            //         snackBar(context, 'Please fill the fields');
                            //       }
                            //       isLoading = false;
                            //       _saveCubit.change();
                            //     },
                            //   );
                            // },
                          }).gapLeft(8.w),
                  ],
                ).sizedBoxW(hfWidth),
              ],
            ),
          ],
        );
      },
    );
  }
}

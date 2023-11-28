import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/blocs/toggle/toggle_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../__shared/dialog/detailed_dialog.dart';
import '../../../../__shared/enum/doc_type.dart';
import '../../../../__shared/widgets/app_button.dart';
import '../../../../__shared/widgets/utils.dart';
import '../../products/widgets/product_details_widget.dart';

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
    List<ProductDetailsModel> productDetails = [];
    final toggleCubit = locator.get<ToggleCubit>();

    final _descriptionController = TextEditingController();
    final _nameController = TextEditingController();
    List<String>? images;

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
        double hfWidth = 175.w;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.products,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                if ((docType != DocType.add))
                  IconButton(
                    onPressed: () {
                      docType = getDocType<ProductModel>(
                          product, docType != DocType.edit);
                      _toggleCubit.change();
                    },
                    icon: Icon(
                      docType == DocType.edit
                          ? Icons.close_outlined
                          : Icons.edit_outlined,
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
            ).sizedBoxW(hfWidth).gapBottom(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      readOnly: docType == DocType.view,
                      controller: _nameController..text = selectedName,
                      label: AppStrings.name,
                    ).gapBottom(16.h),
                    AppTextField(
                      readOnly: docType == DocType.view,
                      controller: _descriptionController
                        ..text = selectedDescription,
                      label: AppStrings.image,
                    ).gapBottom(8.h),
                    AppButton(
                      onTap: () {},
                      label: '${AppStrings.add} ${AppStrings.image}',
                    ).gapBottom(8.h),
                    // ignore: unnecessary_null_comparison
                    if (images != null && images.isNotEmpty)
                      CarouselSlider(
                        options: CarouselOptions(),
                        items: images
                            .map(
                              (image) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    child: IconButton(
                                      onPressed: () {
                                        images.removeAt(images.indexOf(image));
                                        _toggleCubit.change();
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ).sizedBox(height: 100.h),
                  ],
                ).flexible(),
                const VerticalDivider(color: Colors.black).paddingH(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppDropDown<ProductType>(
                      value: _selectedType,
                      items: ProductType.values,
                      onChanged: (val) {
                        if (val != null) {
                          _selectedType == val;
                        }
                      },
                    ).gapBottom(8.h),
                    BlocBuilder<ToggleCubit, bool>(
                      bloc: toggleCubit..initialValue(false),
                      builder: (_, state) {
                        if (productDetails.isNotEmpty) {
                          return Column(
                            children: productDetails
                                .map(
                                  (details) => Row(
                                    children: [
                                      Text('Price: ${details.price}')
                                          .gapRight(4.w),
                                      Text('Discounter Price: ${details.discountedPrice}')
                                          .gapRight(4.w),
                                      Text('Quantity: ${details.qty}')
                                          .gapRight(4.w),
                                      Text('Type: ${details.type.name}')
                                          .gapRight(4.w),
                                      if (docType != DocType.view)
                                        GestureDetector(
                                          onTap: () {
                                            productDetails.remove(details);
                                            toggleCubit.change();
                                          },
                                          child:
                                              const Icon(Icons.remove_circle),
                                        ),
                                      if (docType != DocType.view)
                                        BlocBuilder<ToggleCubit, bool>(
                                          bloc: _toggleCubit,
                                          builder: (_, __) {
                                            return AppButton(
                                              label:
                                                  '${AppStrings.edit} ${AppStrings.details}',
                                              onTap: () async {
                                                final result =
                                                    await showDetailedDialog(
                                                  context,
                                                  child:
                                                      const ProductDetailWidget(),
                                                );
                                                if (result != null &&
                                                    result
                                                        is ProductDetailsModel) {
                                                  productDetails.add(result);
                                                  toggleCubit.change();
                                                }
                                              },
                                            );
                                          },
                                        ).gapBottom(8.h),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ).flexible(),
              ],
            ).sizedBoxW(hfWidth).gapBottom(32.h),
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
                        //   AppButton.positive(
                        //       isLoading: isLoading,
                        //       padding: paddingButton,
                        //       onTap: () async {
                        //         isLoading = true;
                        //         _saveCubit.change();

                        //         final name = _nameController.text.trim();
                        //         final description = _descriptionController.text.trim();
                        //         if (name.isNotEmpty && description.isNotEmpty) {
                        //           if (docType == DocType.add) {
                        //             _productCubit.addProduct(name: '', category: , description: '', productDetails: []

                        //             );
                        //   } else {
                        //     if (product != null) {
                        //       await _productCubit.updateProducts(
                        //         ProductModel(
                        //           id: product!.id,
                        //           name: name,
                        //           category: ,
                        //           description: description,
                        //           active: selectedStatus, productDetails: [],
                        //         ),
                        //       );
                        //     }
                        //   }

                        //           Navigator.pop(context);
                        //         } else {
                        //           snackBar(context, 'Please fill the fields');
                        //         }
                        //         isLoading = false;
                        //         _saveCubit.change();
                        //       },
                        //     );
                        //   },
                        // }).gapLeft(8.w),
                      })
              ],
            ).sizedBoxW(hfWidth),
          ],
        );
      },
    );
  }
}

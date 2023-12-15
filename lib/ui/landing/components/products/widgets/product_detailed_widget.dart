import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
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
import 'detailed_dialog_widget.dart';

class ProductDetailedWidget extends StatelessWidget {
  final ProductModel? product;

  const ProductDetailedWidget({
    super.key,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _productCubit = locator.get<ProductsCubit>();
    final _refreshCubit = locator.get<RefreshCubit>();
    final _switchCubit = locator.get<RefreshCubit>();
    final _saveCubit = locator.get<RefreshCubit>();
    final _productDetailsRefreshCubit = locator.get<RefreshCubit>();

    List<ProductDetailsModel> productDetails = [];
    late CategoryModel selectedCategory;
    final fieldWidth = size.width / 4;

    final _descriptionController = TextEditingController();
    final _nameController = TextEditingController();
    final _imageController = TextEditingController();

    late String selectedName = '';
    late String selectedDescription = '';
    late String selectedImage = '';
    late bool selectedStatus = true;
    late List<String> selectedImages = [];

    DocType docType = getDocType<ProductModel>(product, false);

    late bool isLoading = false;
    _resetForm() {
      if (product != null) {
        selectedCategory = product!.category;
        selectedName = product!.name;
        selectedDescription = product!.description;
        selectedStatus = product!.active;
        selectedImages = product!.images ?? [];
        productDetails = product!.productDetails;
      }
    }

    _resetForm(); //editand view

    final paddingButton = EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h);
    return BlocBuilder<RefreshCubit, bool>(
        bloc: _refreshCubit,
        builder: (_, state) {
          double hfWidth = 280.w;
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
                        AppStrings.products,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      if ((docType != DocType.add))
                        IconButton(
                          onPressed: () {
                            docType = getDocType<ProductModel>(
                                product, docType != DocType.edit);
                            _refreshCubit.change();
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
                      BlocBuilder<RefreshCubit, bool>(
                        bloc: _switchCubit..initialValue(true),
                        builder: (_, __) {
                          return AppSwitch(
                            postiveLabel: AppStrings.active,
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppTextField(
                            width: fieldWidth,
                            readOnly: docType == DocType.view,
                            controller: _nameController..text = selectedName,
                            label: AppStrings.name,
                          ).gapBottom(16.h),
                          AppTextField(
                            width: fieldWidth,
                            readOnly: docType == DocType.view,
                            controller: _descriptionController
                              ..text = selectedDescription,
                            label: AppStrings.description,
                          ).gapBottom(8.h),
                          if ((docType != DocType.view))
                            Row(
                              children: [
                                const Text(
                                        '${AppStrings.add} ${AppStrings.image}')
                                    .gapRight(4.w),
                                FloatingActionButton(
                                  onPressed: () async {
                                    _productCubit.uploadProductImageToStorage();
                                  },
                                  child: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ).gapBottom(8.h),
                          if (product != null &&
                              product!.images != null &&
                              product!.images!.isNotEmpty)
                            SizedBox(
                              width: fieldWidth,
                              child: CarouselSlider(
                                options: CarouselOptions(disableCenter: true),
                                items: [...product!.images!, ...selectedImages]
                                    .map(
                                      (image) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                          ),
                                          if (docType != DocType.view)
                                            Positioned(
                                              bottom: 0.0,
                                              child: IconButton(
                                                onPressed: () {
                                                  selectedImages.remove(image);
                                                  _refreshCubit.change();
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
                              ),
                            )
                        ],
                      ).flexible(),
                      SizedBox(width: 20.w),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocBuilder<CategoriesCubit, CategoriesState>(
                                bloc: locator.get<CategoriesCubit>()
                                  ..fetchCategories(),
                                builder: (context, state) {
                                  if (state is CategoriesResponseState) {
                                    final refreshCubit =
                                        locator.get<RefreshCubit>();
                                    final categories = state.categories;
                                    if (categories.isNotEmpty) {
                                      if (docType == DocType.add) {
                                        selectedCategory = categories.first;
                                      }
                                      return BlocBuilder<RefreshCubit, bool>(
                                        bloc: refreshCubit,
                                        builder: (_, index) {
                                          return AppDropDown<CategoryModel>(
                                            value: selectedCategory,
                                            items: categories,
                                            onChanged: (CategoryModel? val) {
                                              if (docType != DocType.view &&
                                                  val != null) {
                                                selectedCategory = val;
                                                refreshCubit.change();
                                              }
                                            },
                                          );
                                        },
                                      );
                                    }
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              if (docType != DocType.view)
                                AppButton(
                                  label:
                                      '${AppStrings.add} ${AppStrings.details}',
                                  onTap: () async {
                                    final result = await showDetailedDialog(
                                      context,
                                      child: const DetailDialogWidget(),
                                    );
                                    if (result != null &&
                                        result is ProductDetailsModel) {
                                      productDetails.add(result);
                                      _productDetailsRefreshCubit.change();
                                    }
                                  },
                                ),
                            ],
                          ).gapBottom(8.h),
                          BlocBuilder<RefreshCubit, bool>(
                            bloc: _productDetailsRefreshCubit
                              ..initialValue(false),
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
                                                  productDetails
                                                      .remove(details);
                                                  _productDetailsRefreshCubit
                                                      .change();
                                                },
                                                child: const Icon(
                                                    Icons.remove_circle),
                                              ),
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
                      ).gapRight(8.w),
                      if (docType != DocType.view)
                        BlocBuilder<RefreshCubit, bool>(
                            bloc: _saveCubit,
                            builder: (_, __) {
                              return AppButton.positive(
                                isLoading: isLoading,
                                padding: paddingButton,
                                onTap: () async {
                                  isLoading = true;
                                  _saveCubit.change();

                                  final name = _nameController.text.trim();
                                  final description =
                                      _descriptionController.text.trim();
                                  if (name.isNotEmpty &&
                                      description.isNotEmpty &&
                                      (selectedImages.isNotEmpty ||
                                          _productCubit
                                              .productImageFiles.isNotEmpty)) {
                                    if (docType == DocType.add) {
                                      _productCubit.addProduct(
                                        name: name,
                                        category: selectedCategory,
                                        description: description,
                                        images: selectedImages,
                                        productDetails: productDetails,
                                      );
                                    } else {
                                      if (product != null) {
                                        await _productCubit.updateProducts(
                                          ProductModel(
                                            id: product!.id,
                                            name: name,
                                            category: selectedCategory,
                                            description: description,
                                            active: selectedStatus,
                                            images: selectedImages,
                                            productDetails: productDetails,
                                          ),
                                        );
                                      }
                                    }

                                    Navigator.pop(context);
                                  } else {
                                    snackBar(context, 'Please fill the fields');
                                  }
                                  isLoading = false;
                                  _saveCubit.change();
                                },
                              );
                            }),
                    ],
                  ).sizedBoxW(hfWidth),
                ],
              ),
            ],
          );
        });
  }
}

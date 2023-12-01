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

import '../../../../../blocs/index/index_cubit.dart';
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
    final size = MediaQuery.of(context).size;
    final _productCubit = locator.get<ProductsCubit>();
    final _toggleCubit = locator.get<ToggleCubit>();
    final _switchCubit = locator.get<ToggleCubit>();
    ProductType _selectedType = ProductType.kg;
    final _saveCubit = locator.get<ToggleCubit>();
    List<ProductDetailsModel> productDetails = [];
    late CategoryModel _selectedCategory;
    final fieldWidth = size.width / 4;

    final toggleCubit = locator.get<ToggleCubit>();

    final _descriptionController = TextEditingController();
    final _nameController = TextEditingController();

    late String selectedName = '';
    late String selectedDescription = '';
    late bool selectedStatus = true;
    late bool isLoading = false;
    late List<String> selectedImages = [];

    DocType docType = getDocType<ProductModel>(product, false);

    _resetForm() {
      if (product != null) {
        _selectedCategory = product!.category;
        selectedName = product!.name;
        selectedDescription = product!.description;
        selectedStatus = product!.active;
        selectedImages.addAll(product!.images!);
        productDetails = product!.productDetails;
      }
    }

    _resetForm();

    final paddingButton = EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h);
    return BlocBuilder<ToggleCubit, bool>(
        bloc: _toggleCubit,
        builder: (_, state) {
          double hfWidth = 245.w;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            Center(
                              child: AppButton.positive(
                                onTap: () {},
                                label: docType == DocType.add
                                    ? '${AppStrings.add} ${AppStrings.image}'
                                    : '${AppStrings.edit} ${AppStrings.image}',
                              ).sizedBox(
                                width: 75.w,
                                height: 40.h,
                              ),
                            ),
                          if (product != null &&
                              product!.images != null &&
                              product!.images!.isNotEmpty)
                            CarouselSlider(
                              options: CarouselOptions(),
                              items: product!.images!
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
                                                selectedImages.removeAt(
                                                    selectedImages
                                                        .indexOf(image));
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
                            )
                        ],
                      ).flexible(),
                      SizedBox(width: 8.w),
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
                                    final indexCubit =
                                        locator.get<IndexCubit>();
                                    final categories = state.categories;
                                    if (categories.isNotEmpty) {
                                      _selectedCategory = categories.first;
                                      return BlocBuilder<IndexCubit, int>(
                                        bloc: indexCubit,
                                        builder: (_, index) {
                                          return AppDropDown<CategoryModel>(
                                            value: _selectedCategory,
                                            items: categories,
                                            onChanged: (CategoryModel? val) {
                                              if (val != null) {
                                                _selectedCategory = val;
                                                indexCubit.onIndexChange(
                                                    categories.indexOf(val));
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
                                BlocBuilder<ToggleCubit, bool>(
                                  bloc: _toggleCubit,
                                  builder: (_, __) {
                                    return AppButton(
                                      label: docType == DocType.add
                                          ? '${AppStrings.add} ${AppStrings.details}'
                                          : '${AppStrings.edit} ${AppStrings.details}',
                                      onTap: () async {
                                        final result = await showDetailedDialog(
                                          context,
                                          child: const ProductDetailWidget(),
                                        );
                                        if (result != null &&
                                            result is ProductDetailsModel) {
                                          productDetails.add(result);
                                          toggleCubit.change();
                                        }
                                      },
                                    );
                                  },
                                ),
                            ],
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
                                                  productDetails
                                                      .remove(details);
                                                  toggleCubit.change();
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
                        BlocBuilder<ToggleCubit, bool>(
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
                                      description.isNotEmpty) {
                                    if (docType == DocType.add) {
                                      _productCubit.addProduct(
                                        name: name,
                                        category: _selectedCategory,
                                        description: description,
                                        productDetails: productDetails,
                                      );
                                    } else {
                                      if (product != null) {
                                        await _productCubit.updateProducts(
                                          ProductModel(
                                            id: product!.id,
                                            name: name,
                                            category: _selectedCategory,
                                            description: description,
                                            active: selectedStatus,
                                            productDetails: [],
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

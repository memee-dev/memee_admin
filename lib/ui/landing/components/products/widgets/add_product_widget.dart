import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/toggle/toggle_cubit.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/dialog/detailed_dialog.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';

import '../../../../../blocs/categories/categories_cubit.dart';
import '../../../../../blocs/index/index_cubit.dart';
import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../../core/shared/app_strings.dart';
import '../../../../../models/product_model.dart';
import '../../../../__shared/enum/doc_type.dart';
import '../../../../__shared/widgets/app_button.dart';
import '../../../../__shared/widgets/app_textfield.dart';
import '../../../../__shared/widgets/dialog_header.dart';
import 'product_details_widget.dart';

class AddProductWidget extends StatelessWidget {
  final ProductModel? product;
  const AddProductWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<ProductsCubit>(),
      child: _AddProductWidget(product),
    );
  }
}

class _AddProductWidget extends StatelessWidget {
  final ProductModel? product;

  _AddProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    final _toggleCubit = locator.get<ToggleCubit>();
    bool enableEdit = false;
    final size = MediaQuery.of(context).size;
    final _productnameController = TextEditingController();
    final _descriptionController = TextEditingController();
    late CategoryModel _selectedCategory;
    List<String>? images;
    List<ProductDetailsModel> productDetails = [];
    final toggleCubit = locator.get<ToggleCubit>();

    DocType docType = getDocType<ProductModel>(product, enableEdit);

    final fieldWidth = size.width / 4;

    _resetForm() {
      if (product != null) {
        _selectedCategory = product!.category;
        _productnameController.text = product!.name;
        _productnameController.text = product?.description ?? '';
        images = product!.images ?? [];
        productDetails = product!.productDetails;
      }
    }

    _resetForm();
    return BlocBuilder<ToggleCubit, bool>(
      bloc: _toggleCubit,
      builder: (_, toggle) {
        return BlocBuilder<CategoriesCubit, CategoriesState>(
          bloc: locator.get<CategoriesCubit>()..fetchCategories(),
          builder: (context, state) {
            if (state is CategoriesResponseState) {
              final indexCubit = locator.get<IndexCubit>();
              final categories = state.categories;
              if (categories.isNotEmpty) {
                _selectedCategory = categories.first;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DialogHeader(
                      label: AppStrings.product,
                      docType: docType,
                      onTap: () {
                        _toggleCubit.change();
                        enableEdit = !enableEdit;
                        if (!enableEdit) {
                          _resetForm();
                        }
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          '${AppStrings.add} ${AppStrings.product}',
                          style: Theme.of(context).textTheme.displaySmall,
                        ).gapRight(24.w),
                      ],
                    ).gapBottom(32.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            AppTextField(
                              width: fieldWidth,
                              controller: _productnameController,
                              label: AppStrings.name,
                            ).gapBottom(8.h),
                            AppTextField(
                              width: fieldWidth,
                              controller: _descriptionController,
                              label: AppStrings.description,
                            ).gapBottom(8.h),
                            AppButton(
                              onTap: () {},
                              label: '${AppStrings.add} ${AppStrings.image}',
                            ).gapBottom(8.h),
                            if (images != null && images!.isNotEmpty)
                              CarouselSlider(
                                options: CarouselOptions(),
                                items: images!
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
                                                images!.removeAt(
                                                    images!.indexOf(image));
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
                        ).gapRight(8.w),
                        Column(
                          children: [
                            BlocBuilder<IndexCubit, int>(
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
                            ).sizedBoxW(fieldWidth).gapBottom(8.h),
                            AppButton(
                              label: '${AppStrings.add} ${AppStrings.product}',
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
                            ).gapBottom(8.h),
                            BlocBuilder<ToggleCubit, bool>(
                              bloc: toggleCubit..initialValue(true),
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
                                                )
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
                        ),
                      ],
                    ).gapBottom(32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton.negative(
                          onTap: () => Navigator.pop(context),
                        ),
                        AppButton.positive(
                          onTap: () {
                            final name = _productnameController.text.trim();
                            final description =
                                _descriptionController.text.trim();

                            if (name.isNotEmpty) {
                              context.read<ProductsCubit>().addProduct(
                                    name: name,
                                    category: _selectedCategory,
                                    description: description,
                                    images: images,
                                    productDetails: productDetails,
                                  );
                              Navigator.pop(context);
                            }
                          },
                        ).gapLeft(8.w),
                      ],
                    )
                  ],
                );
              }
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

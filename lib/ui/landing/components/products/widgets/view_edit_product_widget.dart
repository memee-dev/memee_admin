import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/models/product_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';

import '../../../../../blocs/categories/categories_cubit.dart';
import '../../../../../blocs/index/index_cubit.dart';
import '../../../../../blocs/products/products_cubit.dart';
import '../../../../../blocs/toggle/toggle_cubit.dart';
import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../../core/shared/app_strings.dart';
import '../../../../../models/category_model.dart';
import '../../../../__shared/dialog/detailed_dialog.dart';
import '../../../../__shared/widgets/app_dropdown.dart';
import '../../../../__shared/widgets/app_textfield.dart';
import 'product_details_widget.dart';

class ViewEditProductWidget extends StatelessWidget {
  final ProductModel product;
  const ViewEditProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<ProductsCubit>(),
      child: _ViewEditProductWidget(product),
    );
  }
}

// ignore: must_be_immutable
class _ViewEditProductWidget extends StatelessWidget {
  final ProductModel product;
  _ViewEditProductWidget(this.product);

  bool enableEdit = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _productnameController =
        TextEditingController(text: product.name);
    final TextEditingController _descriptionController =
        TextEditingController(text: product.description);
    CategoryModel _selectedCategory = product.category;
    List<String> images = [];
    List<ProductDetailsModel> productDetails = product.productDetails;
    final toggleCubit = locator.get<ToggleCubit>();

    final fieldWidth = size.width / 4;
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      bloc: locator.get<CategoriesCubit>()..fetchCategories(),
      builder: (context, state) {
        if (state is CategoriesResponseState) {
          final indexCubit = locator.get<IndexCubit>();
          final categories = state.categories;
          if (categories.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.product,
                  style: Theme.of(context).textTheme.displaySmall,
                ).gapBottom(32.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        AppTextField(
                          readOnly: !enableEdit,
                          width: fieldWidth,
                          controller: _productnameController,
                          label: AppStrings.name,
                        ).gapBottom(8.h),
                        AppTextField(
                          readOnly: !enableEdit,
                          width: fieldWidth,
                          controller: _descriptionController,
                          label: AppStrings.description,
                        ).gapBottom(8.h),
                        if (enableEdit)
                          AppButton(
                            onTap: () {},
                            label: '${AppStrings.add} ${AppStrings.image}',
                          ).gapBottom(8.h),
                        if (images.isNotEmpty)
                          ...images
                              .map((e) => Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0.0,
                                        child: IconButton(
                                          onPressed: () => images
                                              .removeAt(images.indexOf(e)),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                      ),
                                      Image.network(e),
                                    ],
                                  ))
                              .toList(),
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
                                  indexCubit
                                      .onIndexChange(categories.indexOf(val));
                                }
                              },
                            );
                          },
                        ).sizedBoxW(fieldWidth).gapBottom(8.h),
                        if (enableEdit)
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
                                          if (enableEdit)
                                            GestureDetector(
                                              onTap: () {
                                                productDetails.remove(details);
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
                    AppButton.negative(onTap: () => Navigator.pop(context)),
                    if (enableEdit)
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
  }
}

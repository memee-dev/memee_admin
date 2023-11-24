import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_dropdown.dart';

import '../../../../../blocs/categories/categories_cubit.dart';
import '../../../../../blocs/index/index_cubit.dart';
import '../../../../../blocs/index/index_cubit.dart';
import '../../../../../core/initializer/app_di_registration.dart';
import '../../../../../core/shared/app_strings.dart';
import '../../../../__shared/widgets/app_button.dart';
import '../../../../__shared/widgets/app_textfield.dart';

class AddProductWidget extends StatelessWidget {
  const AddProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<CategoriesCubit>(),
      child: const _AddProductWidget(),
    );
  }
}

class _AddProductWidget extends StatelessWidget {
  const _AddProductWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _productnameController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    late CategoryModel _selectedCategory;

    final fieldWidth = size.width / 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${AppStrings.add} ${AppStrings.product}',
          style: Theme.of(context).textTheme.displaySmall,
        ).gapBottom(32.h),
        Row(
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
              ],
            ).gapRight(8.w),
            Column(
              children: [
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  bloc: locator.get<CategoriesCubit>()..fetchCategories(),
                  builder: (_, state) {
                    if (state is CategoriesResponseState) {
                      final indexCubit = locator.get<IndexCubit>();
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
                                  indexCubit.onIndexChange(categories.indexOf(val));
                                }
                              },
                            );
                          },
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ).sizedBoxW(fieldWidth).gapBottom(8.h),
                AppTextField(
                  width: fieldWidth,
                  controller: _descriptionController,
                  label: AppStrings.name,
                ).gapBottom(8.h),
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
                // category.name = _categorynameController.text.toString().trim();
                context.read<ProductsCubit>().addProduct(
                  name: '',
                  categoryId: '',
                  categoryName: '',
                  description: '',
                  images: [],
                  productDetails: [],
                );
                Navigator.pop(context);
              },
            ).gapLeft(8.w),
          ],
        )
      ],
    );
  }
}

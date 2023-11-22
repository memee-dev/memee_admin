import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../../blocs/index/index_cubit.dart';
import '../../../../__shared/widgets/app_button.dart';

class CategoriesDetailedWidget extends StatelessWidget {
  final CategoryModel? category;
  const CategoriesDetailedWidget({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<CategoriesCubit>(),
      child: _CategoryDetailed(category: category),
    );
  }
}

class _CategoryDetailed extends StatefulWidget {
  final CategoryModel? category;

  const _CategoryDetailed({
    required this.category,
  });

  @override
  State<_CategoryDetailed> createState() => _CategoryDetailedState();
}

class _CategoryDetailedState extends State<_CategoryDetailed> {
  final TextEditingController _categorynameController = TextEditingController();

  bool enableAdd = false;

  late CategoryModel category;
  late String selectedId = '';
  late String selectedCategoryName = '';

  final indexCubit = locator.get<IndexCubit>();
  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      category = widget.category!;
      _resetForm(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.category,
              style: Theme.of(context).textTheme.displaySmall,
            ).gapLeft(8.w)
          ],
        ).gapBottom(32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedId.isNotEmpty ? 'ID: ${category.id}' : AppStrings.add,
              style: Theme.of(context).textTheme.titleSmall,
            ).gapBottom(16),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _categorynameController
                    ..text = selectedCategoryName,
                  label: AppStrings.name,
                ).gapBottom(16.h),
              ],
            ).flexible(),
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
                context.read<CategoriesCubit>().addCategory(_categorynameController.text);
                Navigator.pop(context);
              },
            ).gapLeft(8.w),
          ],
        )
      ],
    );
  }

  _resetForm(CategoryModel category) {
    selectedId = category.id;
    selectedCategoryName = category.name;
  }

  @override
  void dispose() {
    _categorynameController.dispose();
    super.dispose();
  }
}

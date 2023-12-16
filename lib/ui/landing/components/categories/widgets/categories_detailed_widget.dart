import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/blocs/toggle/toggle_cubit.dart';
import 'package:memee_admin/core/initializer/app_di_registration.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_switch.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/__shared/widgets/utils.dart';

import '../../../../__shared/enum/doc_type.dart';
import '../../../../__shared/widgets/app_button.dart';

class CategoriesDetailedWidget extends StatelessWidget {
  final CategoryModel? category;

  const CategoriesDetailedWidget({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final _categoryCubit = locator.get<CategoriesCubit>();
    final _toggleCubit = locator.get<RefreshCubit>();
    final _switchCubit = locator.get<RefreshCubit>();
    final _saveCubit = locator.get<RefreshCubit>();

    final _categoryNameController = TextEditingController();
    final _imageController = TextEditingController();

    late String selectedCategoryName = '';
    late String selectedImage = '';
    late bool selectedStatus = true;

    DocType docType = getDocType<CategoryModel>(category, false);

    _resetForm() {
      if (category != null) {
        selectedCategoryName = category!.name;
        selectedImage = category!.image;
        selectedStatus = category!.active;
      }
    }

    _resetForm();

    return BlocBuilder<RefreshCubit, bool>(
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
                          docType = getDocType<CategoryModel>(
                              category, docType != DocType.edit);
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
                      (docType != DocType.add) ? 'ID: ${category!.id}' : '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    BlocBuilder<RefreshCubit, bool>(
                      bloc: _switchCubit..initialValue(true),
                      builder: (_, __) {
                        return AppSwitch(
                          value: selectedStatus,
                          enableEdit: docType != DocType.view,
                          showConfirmationDialog: false,
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
                  controller: _categoryNameController
                    ..text = selectedCategoryName,
                  label: AppStrings.name,
                ).gapBottom(8.h),
                AppTextField(
                  readOnly: docType == DocType.view,
                  controller: _imageController..text = selectedImage,
                  label: AppStrings.image,
                ).gapBottom(32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton.secondary(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(context),
                    ),
                    if (docType != DocType.view)
                      BlocBuilder<RefreshCubit, bool>(
                        bloc: _saveCubit,
                        builder: (_, __) {
                          return AppButton.secondary(
                            label: 'Save',
                            onTap: () async {
                              _saveCubit.change();

                              final name = _categoryNameController.text.trim();
                              final image = _imageController.text.trim();
                              if (name.isNotEmpty && image.isNotEmpty) {
                                if (docType == DocType.add) {
                                  _categoryCubit.addCategory(
                                    name,
                                    image,
                                    selectedStatus,
                                  );
                                } else {
                                  if (category != null) {
                                    await _categoryCubit.updateCategory(
                                      CategoryModel(
                                        id: category!.id,
                                        name: name,
                                        image: image,
                                        active: selectedStatus,
                                      ),
                                    );
                                  }
                                }

                                Navigator.pop(context);
                              } else {
                                snackBar(context, 'Please fill the fields');
                              }
                              _saveCubit.change();
                            },
                          );
                        },
                      ).gapLeft(8.w),
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

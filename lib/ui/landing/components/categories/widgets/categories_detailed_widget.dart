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
    final _toggleCubit = locator.get<ToggleCubit>();

    final _categorynameController = TextEditingController();
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

    final paddingButton = EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h);
    return BlocBuilder<ToggleCubit, bool>(
      bloc: _toggleCubit,
      builder: (_, state) {
        print('onBuilder=>docType: $docType, docType != DocType.view: ${docType != DocType.view}');
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
                          docType = getDocType<CategoryModel>(category, docType != DocType.edit);
                          print('onPressed=>docType: $docType');
                          _toggleCubit.change();
                        },
                        icon: Icon(
                          docType == DocType.edit ? Icons.close_outlined : Icons.edit_outlined,
                        ),
                      ),
                  ],
                ).sizedBoxW(null).gapBottom(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (docType != DocType.add) ? 'ID: ${category!.id}' : '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppSwitch(
                      value: selectedStatus,
                      enableEdit: docType != DocType.view,
                      showConfirmationDailog: false,
                      onTap: (bool val) {
                        selectedStatus = val;
                        _toggleCubit.change();
                      },
                    )
                  ],
                ).sizedBoxW(null).gapBottom(12.h),
                AppTextField(
                  readOnly: docType == DocType.view,
                  controller: _categorynameController..text = selectedCategoryName,
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
                    AppButton.negative(
                      padding: paddingButton,
                      onTap: () => Navigator.pop(context),
                    ),
                    if (docType != DocType.view)
                      AppButton.positive(
                        padding: paddingButton,
                        onTap: () {
                          _categoryCubit.addCategory(
                            _categorynameController.text,
                            _imageController.text,
                            selectedStatus,
                          );
                          Navigator.pop(context);
                        },
                      ).gapLeft(8.w),
                  ],
                ).sizedBoxW(null),
              ],
            ),
          ],
        );
      },
    );
  }
}

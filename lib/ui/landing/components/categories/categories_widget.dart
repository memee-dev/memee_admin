import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/dialog/confirmation_dialog.dart';
import 'package:memee_admin/ui/__shared/dialog/detailed_dialog.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/landing/components/categories/widgets/categories_detailed_widget.dart';

import '../../../../blocs/categories/categories_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import 'data-row/categories_data_row.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _categoriesCubit = locator.get<CategoriesCubit>();

    return Stack(children: [
      Positioned(
        right: 16.w,
        bottom: 48.h,
        child: FloatingActionButton(
          onPressed: () => showDetailedDialog(
            context,
            child: const CategoriesDetailedWidget(),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: AppTextField(
                  controller: _searchController,
                  label: '${AppStrings.search} ${AppStrings.categories}',
                ),
              ).gapRight(24.w),
              Flexible(
                child: BlocProvider(
                  create: (_) => locator.get<ExportImportCubit>(),
                  child: BlocBuilder<ExportImportCubit, ExportImportState>(
                    bloc: locator.get<ExportImportCubit>(),
                    builder: (ctx, state) {
                      return AppButton(
                        isLoading: state == ExportImportState.loading,
                        label: AppStrings.import,
                        onTap: () {
                          ctx.read<ExportImportCubit>().importExcel<CategoryModel>();
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: BlocProvider(
                  create: (_) => locator.get<ExportImportCubit>(),
                  child: BlocBuilder<ExportImportCubit, ExportImportState>(
                    builder: (ctx, state) {
                      return AppButton(
                        isLoading: state == ExportImportState.loading,
                        label: AppStrings.export,
                        onTap: () {
                          if (_categoriesCubit.state is CategoriesSuccess) {
                            ctx.read<ExportImportCubit>().exportExcel<CategoryModel>(
                                  data: (_categoriesCubit.state as CategoriesSuccess).categories,
                                  sheetName: AppStrings.categories,
                                  title: AppColumn.categories,
                                );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<CategoriesCubit, CategoriesState>(
                bloc: _categoriesCubit..fetchCategories(),
                builder: (context, state) {
                  if (state is CategoriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is CategoriesResponseState) {
                    if (state.categories.isEmpty) {
                      return const EmptyWidget(label: '${AppStrings.no} ${AppStrings.categories}');
                    }
                    return AppDataTable(
                      headers: AppColumn.categories,
                      items: state.categories
                          .map((category) => categoryDataRow(
                                context,
                                category: category,
                                onSelectChanged: (selected) async {
                                  final result = await showDetailedDialog(
                                    context,
                                    child: CategoriesDetailedWidget(category: category),
                                  );
                                  if (result != null && result is CategoryModel) {
                                    category = result;
                                  }
                                },
                                onDelete: () {
                                  showConfirmationDialog(
                                    context,
                                    onTap: (bool val) {
                                      if (val) {
                                        _categoriesCubit.deleteCategory(category);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ))
                          .toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ).paddingS(),
    ]);
  }
}

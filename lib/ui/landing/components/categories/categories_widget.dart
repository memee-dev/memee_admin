import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/dialog/confirmation_dialog.dart';
import 'package:memee_admin/ui/__shared/dialog/detailed_dialog.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/landing/components/categories/widgets/categories_detailed_widget.dart';

import '../../../../blocs/categories/categories_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import '../../../__shared/widgets/search_export_import_widget.dart';
import 'data-row/categories_data_row.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _categoriesCubit = locator.get<CategoriesCubit>();
    final _exportImport = locator.get<ExportImportCubit>();

    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchExportImportWidget(
            searchController: _searchController,
            searchLabel: '${AppStrings.search} ${AppStrings.categories}',
            onExportPressed: () => _exportImport.exportCSV<CategoryModel>(),
            onImportPressed: () async {
              await _exportImport.importCSV<CategoryModel>();
              _categoriesCubit.refresh();
            },
          ),
          Expanded(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              bloc: _categoriesCubit..fetchCategories(clear: true),
              builder: (context, state) {
                 if (state is CategoriesEmpty) {
                    return const EmptyWidget(
                        label: '${AppStrings.no} ${AppStrings.categories}');
                  }
               else if (state is CategoriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is CategoriesResponseState) {
                  if (state.categories.isEmpty) {
                    return const EmptyWidget(
                        label: '${AppStrings.no} ${AppStrings.categories}');
                  }
                  return NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        _categoriesCubit.fetchCategories();
                      }
                      return true;
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        AppDataTable(
                          headers: AppColumn.categories,
                          items: _categoriesCubit.categories
                              .map((category) => categoryDataRow(
                                    context,
                                    category: category,
                                    onSelectChanged: (selected) async {
                                      final result = await showDetailedDialog(
                                        context,
                                        child: CategoriesDetailedWidget(
                                          category: category,
                                        ),
                                      );
                                      if (result != null &&
                                          result is CategoryModel) {
                                        category = result;
                                      }
                                    },
                                    onDelete: () {
                                      showConfirmationDialog(
                                        context,
                                        onTap: (bool val) {
                                          if (val) {
                                            _categoriesCubit
                                                .deleteCategory(category);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ).paddingS(),
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
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/category_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../blocs/categories/categories_cubit.dart';
import '../../core/initializer/app_di_registration.dart';

class CategoriesWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final _categoriesCubit = locator.get<CategoriesCubit>();

  CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
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
                            ctx
                                .read<ExportImportCubit>()
                                .exportExcel<CategoryModel>(
                                  data: (_categoriesCubit.state
                                          as CategoriesSuccess)
                                      .categories,
                                  sheetName: AppStrings.categories,
                                  title: AppStrings.categoriesTitle,
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
                } else if (state is CategoriesFailure) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is CategoriesSuccess) {
                  return DataTable(
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn(
                        label: Text('Name'),
                      ),
                    ],
                    rows: state.categories.map((category) {
                      return DataRow(
                        cells: [
                          DataCell(Text(category.id)),
                          DataCell(Text(category.name)),
                        ],
                        onSelectChanged: (selected) {
                          if (selected != null && selected) {
                            //_showProductDetails(product);
                          }
                        },
                      );
                    }).toList(), // Helper function to build rows
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    ).paddingS();
  }
}

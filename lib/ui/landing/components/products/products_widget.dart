import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../blocs/export_import/export_import_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../../models/product_model.dart';
import '../../../__shared/dialog/confirmation_dialog.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/app_button.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import 'data-row/product_data_row.dart';
import 'widgets/product_detailed_widget.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _productsCubit = locator.get<ProductsCubit>();

    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: FloatingActionButton(
            onPressed: () => showDetailedDialog(
              context,
              child: const ProductDetailedWidget(),
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
                    label: '${AppStrings.search} ${AppStrings.products}',
                    onChanged: (val) async {
                      _productsCubit.searchProducts(val);
                    },
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
                            ctx
                                .read<ExportImportCubit>()
                                .importExcel<ProductModel>();
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
                            if (_productsCubit.state is ProductsSuccess) {
                              ctx
                                  .read<ExportImportCubit>()
                                  .exportExcel<ProductModel>(
                                    data: (_productsCubit.state
                                            as ProductsSuccess)
                                        .products,
                                    sheetName: AppStrings.products,
                                    title: AppColumn.products,
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
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  bloc: _productsCubit..fetchProducts(),
                  builder: (context, state) {
                    if (state is ProductsLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is ProductsResponseState) {
                      if (state.products.isEmpty) {
                        return const EmptyWidget(
                            label: '${AppStrings.no} ${AppStrings.products}');
                      }
                      return AppDataTable(
                        headers: AppColumn.products,
                        items: state.products
                            .map((product) => productDataRow(
                                  context,
                                  product: product,
                                  onSelectChanged: (selected) async {
                                    final result = await showDetailedDialog(
                                      context,
                                      child: ProductDetailedWidget(
                                          product: product),
                                    );
                                    if (result != null &&
                                        result is ProductModel) {
                                      product = result;
                                    }
                                  },
                                  onDelete: () {
                                    showConfirmationDialog(
                                      context,
                                      onTap: (bool val) {
                                        if (val) {
                                          _productsCubit
                                              .deleteProducts(product);
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
      ],
    );
  }
}

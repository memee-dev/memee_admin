import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../core/initializer/app_di_registration.dart';
import '../../../../models/product_model.dart';
import '../../../__shared/dialog/confirmation_dialog.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import '../products/widgets/add_product_widget.dart';
import 'data-row/product_2_data_row.dart';
import 'widgets/product_2_detailed_widget.dart';

class ProductsWidget2 extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final productsCubit = locator.get<ProductsCubit>();

  final dataColumnHeaders = [
    'ID',
    'Name',
    'Status',
  ];

  ProductsWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: FloatingActionButton(
            onPressed: () => showDetailedDialog(
              context,
              child: const Products2DetailedWidget(),
            ),
            child: const Icon(Icons.add),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppTextField(
                controller: _searchController,
                label: '${AppStrings.search} ${AppStrings.products}',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  bloc: productsCubit..fetchProducts(),
                  builder: (context, state) {
                    if (state is ProductsLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is ProductsFailure) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is ProductsResponseState) {
                      if (state.products.isEmpty) {
                        return const EmptyWidget(label: '${AppStrings.no} ${AppStrings.products}');
                      }
                      return 
                      AppDataTable(
                        headers: dataColumnHeaders,
                        items: state.products
                            .map((product) => product2DataRow(
                                  context,
                                  product: product,
                                  onSelectChanged: (selected) async {
                                    final result = await showDetailedDialog(
                                      context,
                                      child: Products2DetailedWidget(product: product),
                                    );
                                    if (result != null && result is ProductModel) {
                                      product = result;
                                    }
                                  },
                                  onDelete: () {
                                    showConfirmationDialog(
                                      context,
                                      onTap: (bool val) {
                                        if (val) {
                                          productsCubit.deleteProducts(product);
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

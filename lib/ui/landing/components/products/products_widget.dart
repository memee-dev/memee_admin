import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/products/products_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';

import '../../../../core/initializer/app_di_registration.dart';

class ProductsWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final productsCubit = locator.get<ProductsCubit>();

  ProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                } else if (state is ProductsSuccess) {
                  return DataTable(
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn(
                        label: Text('Name'),
                      ),
                      DataColumn(
                        label: Text('Description'),
                      ),
                    ],
                    rows: state.products.map((product) {
                      return DataRow(
                        cells: [
                          DataCell(Text(product.id)),
                          DataCell(Text(product.name)),
                          DataCell(Text(product.description)),
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

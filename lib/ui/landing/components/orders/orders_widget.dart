import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/landing/components/orders/data-row/orders_data_row.dart';
import '../../../../blocs/orders/orders_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../../models/order_model.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import '../../../__shared/widgets/search_export_import_widget.dart';
import 'widgets/orders_detailed_widget.dart';

class OrdersWidget extends StatelessWidget {
  const OrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _ordersCubit = locator.get<OrdersCubit>();
    final _exportImport = locator.get<ExportImportCubit>();

    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchExportImportWidget(
            searchController: _searchController,
            searchLabel: '${AppStrings.search} ${AppStrings.orders}',
            onExportPressed: () => _exportImport.exportCSV<OrderModel>(),
            onImportPressed: () async {
              await _exportImport.importCSV<OrderModel>();
              _ordersCubit.refresh();
            },
          ),
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              bloc: _ordersCubit..fetchOrders(clear: true),
              builder: (context, state) {
                if (state is OrdersEmpty) {
                  return const EmptyWidget(
                      label: '${AppStrings.no} ${AppStrings.orders}');
                } else if (state is OrdersLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is OrdersResponseState) {
                  if (state.orders.isEmpty) {
                    return const EmptyWidget(
                        label: '${AppStrings.no} ${AppStrings.orders}');
                  }
                  return NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        _ordersCubit.fetchOrders();
                      }
                      return true;
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        AppDataTable(
                          headers: AppColumn.orders,
                          items: _ordersCubit.orders
                              .map((order) => orderDataRow(
                                    context,
                                    order: order,
                                    onSelectChanged: (selected) async {
                                      final result = await showDetailedDialog(
                                        context,
                                        child: OrdersDetailedWidget(
                                          order: order,
                                        ),
                                      );
                                      if (result != null &&
                                          result is OrderModel) {
                                        order = result;
                                      }
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
    ]);
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/landing/components/orders/data-row/orders_data_row.dart';
import '../../../../blocs/orders/orders_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../../models/order_model.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';


class OrdersWidget extends StatelessWidget {
  const OrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _ordersCubit = locator.get<OrdersCubit>();

    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: AppTextField(
                  controller: _searchController,
                  label: '${AppStrings.search} ${AppStrings.orders}',
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
                              .importExcel<OrderModel>();
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
                          if (_ordersCubit.state is OrdersSuccess) {
                            ctx
                                .read<ExportImportCubit>()
                                .exportExcel<OrderModel>(
                                  data:
                                      (_ordersCubit.state as OrdersSuccess)
                                          .orders,
                                  sheetName: AppStrings.orders,
                                  title: AppColumn.orders,
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
              child: BlocBuilder<OrdersCubit, OrdersState>(
                bloc: _ordersCubit..fetchOrders(),
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is OrdersResponseState) {
                    if (state.orders.isEmpty) {
                      return const EmptyWidget(
                          label: '${AppStrings.no} ${AppStrings.orders}');
                    }
                    return AppDataTable(
                      headers: AppColumn.orders,
                      items: state.orders
                          .map((order) => orderDataRow(
                                context,
                                order: order,
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

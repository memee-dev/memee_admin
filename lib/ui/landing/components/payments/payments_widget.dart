import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/payment_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import '../../../../blocs/payments/payments_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import '../../../__shared/widgets/search_export_import_widget.dart';
import 'data-row/payments_data_row.dart';

class PaymentsWidget extends StatelessWidget {
  const PaymentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _paymentsCubit = locator.get<PaymentsCubit>();
    final _exportImport = locator.get<ExportImportCubit>();

    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchExportImportWidget(
            searchController: _searchController,
            searchLabel: '${AppStrings.search} ${AppStrings.payment}',
            onExportPressed: () => _exportImport.exportCSV<PaymentModel>(),
            onImportPressed: () async {
              await _exportImport.importCSV<PaymentModel>();
              _paymentsCubit.refresh();
            },
          ),
          Expanded(
            child: BlocBuilder<PaymentsCubit, PaymentsState>(
              bloc: _paymentsCubit..fetchPayments(clear: true),
              builder: (context, state) {
                if (state is PaymentsEmpty) {
                     return const EmptyWidget(
                        label: '${AppStrings.no} ${AppStrings.payments}');
                }
                else if (state is PaymentsLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is PaymentsResponseState) {
                  if (state.payments.isEmpty) {
                    return const EmptyWidget(
                        label: '${AppStrings.no} ${AppStrings.payments}');
                  }
                  return NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        _paymentsCubit.fetchPayments();
                      }
                      return true;
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        AppDataTable(
                          headers: AppColumn.payments,
                          items: _paymentsCubit.payments
                              .map((payment) => paymentDataRow(
                                    context,
                                    payment: payment,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/payment_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import '../../../../blocs/payments/payments_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../core/shared/app_column.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import 'data-row/payments_data_row.dart';

class PaymentsWidget extends StatelessWidget {
  const PaymentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _paymentsCubit = locator.get<PaymentsCubit>();

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
                  label: '${AppStrings.search} ${AppStrings.payments}',
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
                              .importExcel<PaymentModel>();
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
                          if (_paymentsCubit.state is PaymentsSuccess) {
                            ctx
                                .read<ExportImportCubit>()
                                .exportExcel<PaymentModel>(
                                  data:
                                      (_paymentsCubit.state as PaymentsSuccess)
                                          .payments,
                                  sheetName: AppStrings.payments,
                                  title: AppColumn.payments,
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
              child: BlocBuilder<PaymentsCubit, PaymentsState>(
                bloc: _paymentsCubit..fetchPayments(),
                builder: (context, state) {
                  if (state is PaymentsLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is PaymentsResponseState) {
                    if (state.payments.isEmpty) {
                      return const EmptyWidget(
                          label: '${AppStrings.no} ${AppStrings.payments}');
                    }
                    return AppDataTable(
                      headers: AppColumn.payments,
                      items: state.payments
                          .map((payment) => paymentDataRow(
                                context,
                                payment: payment,
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

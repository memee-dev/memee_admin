import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_column.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/dl_executive_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../__shared/dialog/confirmation_dialog.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import 'data-row/dl_executive_data_row.dart';
import 'widgets/dl_detailed_widget.dart';

class DLExecutiveWidget extends StatelessWidget {
  const DLExecutiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _dlCubit = locator.get<DlExecutiveCubit>();

    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: FloatingActionButton(
            onPressed: () {
              showDetailedDialog(
                context,
                child: const DLDetailed(),
              );
            },
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
                    label: '${AppStrings.search} ${AppStrings.users}',
                  ),
                ).gapRight(24.w),
                Flexible(
                  child: BlocProvider(
                    create: (_) => locator.get<ExportImportCubit>(),
                    child: BlocBuilder<ExportImportCubit, ExportImportState>(
                      bloc: locator.get<ExportImportCubit>(),
                      builder: (ctx, state) {
                        return AppButton(
                          label: AppStrings.import,
                          onTap: () {
                            ctx
                                .read<ExportImportCubit>()
                                .importCSV<DlExecutiveModel>();
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
                          label: AppStrings.export,
                          onTap: () {
                            if (_dlCubit.state is DlExecutivesSuccess) {
                              ctx
                                  .read<ExportImportCubit>()
                                  .exportCSV<DlExecutiveModel>();
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
                child: BlocBuilder<DlExecutiveCubit, DlExecutivesState>(
                  bloc: _dlCubit..fetchDlExecutives(),
                  builder: (context, state) {
                    if (state is DlExecutivesLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is DlExecutivesResponseState) {
                      if (state.dlExecutives.isEmpty) {
                        return const EmptyWidget(
                            label:
                                '${AppStrings.no} ${AppStrings.dlExecutive}');
                      }
                      return AppDataTable(
                        headers: AppColumn.dlExecutives,
                        items: state.dlExecutives
                            .map((dlExecutive) => dlExecutiveDataRow(
                                  context,
                                  dlExecutive: dlExecutive,
                                  onSelectChanged: (selected) async {
                                    final result = await showDetailedDialog(
                                      context,
                                      child:
                                          DLDetailed(dlExecutive: dlExecutive),
                                    );
                                    if (result != null &&
                                        result is DlExecutiveModel) {
                                      dlExecutive = result;
                                    }
                                  },
                                  onDelete: () {
                                    showConfirmationDialog(
                                      context,
                                      onTap: (bool val) {
                                        if (val) {
                                          _dlCubit
                                              .deleteDlExecutive(dlExecutive);
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

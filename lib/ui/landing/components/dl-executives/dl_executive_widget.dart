import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/dl_executive_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/landing/components/dl-executives/data-row/dl_executive_data_row.dart';
import 'package:memee_admin/ui/landing/components/dl-executives/widgets/dl_executive_detailed_widget.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';

class DLExecutiveWidget extends StatelessWidget {
  const DLExecutiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<DlExecutiveCubit>(),
      child: _DLExecutiveWidget(),
    );
  }
}

class _DLExecutiveWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  final dataColumnHeaders = [
    'Name',
    'Email',
    'PhoneNumber',
    'Alloted',
    'Status',
  ];

  @override
  Widget build(BuildContext context) {
    final dlExecutiveCubit = context.read<DlExecutiveCubit>();
    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: FloatingActionButton(
            onPressed: () {
              showDetailedDialog(context, child: const DLExecutiveDetailed());
            },
            child: const Icon(Icons.add),
          ),
        ),
        Column(
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
                            isLoading: state == ExportImportState.loading,
                            label: AppStrings.import,
                            onTap: () {
                              ctx
                                  .read<ExportImportCubit>()
                                  .importExcel<DlExecutiveModel>();
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
                              if (dlExecutiveCubit.state
                                  is DlExecutivesSuccess) {
                                ctx
                                    .read<ExportImportCubit>()
                                    .exportExcel<DlExecutiveModel>(
                                      data: (dlExecutiveCubit.state
                                              as DlExecutivesSuccess)
                                          .dlExecutives,
                                      sheetName: AppStrings.users,
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
                child: BlocBuilder<DlExecutiveCubit, DlExecutivesState>(
                  bloc: dlExecutiveCubit..fetchDlExecutives(),
                  builder: (context, state) {
                    if (state is DlExecutivesLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is DlExecutivesFailure) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is DlExecutivesSuccess) {
                      return AppDataTable(
                        headers: dataColumnHeaders,
                        items: state.dlExecutives
                            .map((dlExecutive) =>
                                dlExecutiveDataRow(context, dlExecutive))
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

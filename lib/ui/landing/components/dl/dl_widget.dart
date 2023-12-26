import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/categories/categories_cubit.dart';
import 'package:memee_admin/blocs/dl_executives/dl_executive_cubit.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_column.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/models/dl_executive_model.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/empty_widget.dart';
import '../../../__shared/widgets/search_export_import_widget.dart';
import 'data-row/dl_executive_data_row.dart';
import 'widgets/dl_detailed_widget.dart';

class DLExecutiveWidget extends StatelessWidget {
  const DLExecutiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _dlCubit = locator.get<DlExecutiveCubit>();
    final _exportImport = locator.get<ExportImportCubit>();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchExportImportWidget(
              searchController: _searchController,
              searchLabel: '${AppStrings.search} ${AppStrings.dlExecutive}',
              onExportPressed: () =>
                  _exportImport.exportCSV<DlExecutiveModel>(),
              onImportPressed: () async {
                await _exportImport.importCSV<DlExecutiveModel>();
                _dlCubit.refresh();
              },
            ),
            Expanded(
              child: BlocBuilder<DlExecutiveCubit, DlExecutivesState>(
                bloc: _dlCubit..fetchDlExecutives(clear: true),
                builder: (context, state) {
                  if (state is CategoriesEmpty) {
                      return const EmptyWidget(
                          label: '${AppStrings.no} ${AppStrings.dlExecutive}');
                    }
                  else if (state is DlExecutivesLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is DlExecutivesResponseState) {
                    if (state.dlExecutives.isEmpty) {
                      return const EmptyWidget(
                          label: '${AppStrings.no} ${AppStrings.dlExecutive}');
                    }
                    return NotificationListener(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          _dlCubit.fetchDlExecutives();
                        }
                        return true;
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          AppDataTable(
                            headers: AppColumn.dlExecutives,
                            items: _dlCubit.dlExecutives
                                .map((dlExecutive) => dlExecutiveDataRow(
                                      context,
                                      dlExecutive: dlExecutive,
                                      onSelectChanged: (selected) async {
                                        final result = await showDetailedDialog(
                                          context,
                                          child: DLDetailed(
                                            dlExecutive: dlExecutive,
                                          ),
                                        );
                                        if (result != null &&
                                            result is DlExecutiveModel) {
                                          dlExecutive = result;
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
      ],
    );
  }
}

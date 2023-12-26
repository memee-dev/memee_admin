import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_column.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/data-table/app_data_table.dart';
import 'package:memee_admin/ui/landing/components/admins/data-row/admin_data_row.dart';
import '../../../../blocs/admins/admins_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../models/admin_model.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/empty_widget.dart';
import '../../../__shared/widgets/search_export_import_widget.dart';
import 'widgets/admin_detailed_widget.dart';

class AdminWidget extends StatelessWidget {
  const AdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _adminCubit = locator.get<AdminCubit>();
    final _exportImport = locator.get<ExportImportCubit>();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchExportImportWidget(
              searchController: _searchController,
              searchLabel: '${AppStrings.search} ${AppStrings.admin}',
              onExportPressed: () => _exportImport.exportCSV<AdminModel>(),
              onImportPressed: () async {
                await _exportImport.importCSV<AdminModel>();
                _adminCubit.refresh();
              },
            ),
            Expanded(
              child: BlocBuilder<AdminCubit, AdminsState>(
                bloc: _adminCubit..fetchAdmins(clear: true),
                builder: (context, state) {
                  if (state is AdminsEmpty) {
                    return const EmptyWidget(
                        label: '${AppStrings.no} ${AppStrings.admins}');
                  } else if (state is AdminsLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is AdminsResponseState) {
                    if (state.admins.isEmpty) {
                      return const EmptyWidget(
                          label: '${AppStrings.no} ${AppStrings.admins}');
                    }
                    return NotificationListener(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          _adminCubit.fetchAdmins();
                        }
                        return true;
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: AppDataTable(
                              headers: AppColumn.admins,
                              items: _adminCubit.admins
                                  .map((admin) => dataRow(
                                        context,
                                        admin: admin,
                                        onSelectChanged: (selected) async {
                                          final result =
                                              await showDetailedDialog(
                                            context,
                                            child: AdminDetailedWidget(
                                              admin: admin,
                                            ),
                                          );
                                          if (result != null &&
                                              result is AdminModel) {
                                            admin = result;
                                          }
                                        },
                                      ))
                                  .toList(),
                            ),
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
          child: AppButton(
            onTap: () => showDetailedDialog(
              context,
              child: const AdminDetailedWidget(),
            ),
            label: 'add',
          ),
        ),
      ],
    );
  }
}

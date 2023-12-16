import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_column.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/__shared/widgets/data-table/app_data_table.dart';
import 'package:memee_admin/ui/landing/components/admins/data-row/admin_data_row.dart';

import '../../../../blocs/admins/admins_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../models/admin_model.dart';
import '../../../__shared/dialog/confirmation_dialog.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/empty_widget.dart';
import 'widgets/admin_detailed_widget.dart';

class AdminWidget extends StatelessWidget {
  const AdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _adminCubit = locator.get<AdminCubit>();

    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: FloatingActionButton(
            onPressed: () => showDetailedDialog(
              context,
              child: const AdminDetailedWidget(),
            ),
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
                      label: '${AppStrings.search} ${AppStrings.admins}',
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
                                  .importCSV<AdminModel>();
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
                              if (_adminCubit.state is AdminsSuccess) {
                                ctx
                                    .read<ExportImportCubit>()
                                    .exportCSV<AdminModel>();
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
                child: BlocBuilder<AdminCubit, AdminsState>(
                  bloc: _adminCubit..fetchAdmins(),
                  builder: (context, state) {
                    if (state is AdminsLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is AdminsResponseState) {
                      if (state.admins.isEmpty) {
                        return const EmptyWidget(
                            label: '${AppStrings.no} ${AppStrings.admins}');
                      }
                      return AppDataTable(
                        headers: AppColumn.admins,
                        items: state.admins
                            .map((admin) => dataRow(
                                  context,
                                  admin: admin,
                                  onSelectChanged: (selected) async {
                                    final result = await showDetailedDialog(
                                      context,
                                      child: AdminDetailedWidget(admin: admin),
                                    );
                                    if (result != null &&
                                        result is AdminModel) {
                                      admin = result;
                                    }
                                  },
                                  onDelete: () {
                                    showConfirmationDialog(
                                      context,
                                      onTap: (bool val) {
                                        if (val) {
                                          _adminCubit.deleteAdmin(admin);
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

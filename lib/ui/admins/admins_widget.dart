import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/admins/widgets/admin_data_row.dart';

import '../../blocs/admins/admins_cubit.dart';
import '../../core/initializer/app_di_registration.dart';
import '../../models/admin_model.dart';
import '../__shared/dialog/detailed_dialog.dart';
import 'widgets/admin_detailed.dart';

class AdminWidget extends StatelessWidget {
  const AdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<AdminCubit>(),
      child: _AdminWidget(),
    );
  }
}

class _AdminWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  _AdminWidget();

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminCubit>();
    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              showDetailedDialog(context, child: const AdminDetailed());
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
                            isLoading: state == ExportImportState.loading,
                            label: AppStrings.import,
                            onTap: () {
                              ctx.read<ExportImportCubit>().importExcel<AdminModel>();
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
                              if (adminCubit.state is AdminsSuccess) {
                                ctx.read<ExportImportCubit>().exportExcel<AdminModel>(
                                      data: (adminCubit.state as AdminsSuccess).admins,
                                      sheetName: AppStrings.admins,
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
                child: BlocBuilder<AdminCubit, AdminsState>(
                  bloc: adminCubit..fetchAdmins(),
                  builder: (context, state) {
                    if (state is AdminsLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is AdminsFailure) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is AdminsSuccess) {
                      return DataTable(
                        showCheckboxColumn: false,
                        columns: const [
                          DataColumn(
                            label: Text('ID'),
                          ),
                          DataColumn(
                            label: Text('Name'),
                          ),
                          DataColumn(
                            label: Text('email'),
                          ),
                          DataColumn(
                            label: Text('Admin Level'),
                          ),
                          DataColumn(
                            label: Text('Status'),
                          ),
                        ],
                        rows: state.admins.map((admin) {
                          return dataRow(context, admin);
                        }).toList(), // Helper function to build rows
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

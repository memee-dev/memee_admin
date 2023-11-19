import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/__shared/widgets/app_button.dart';
import 'package:memee_admin/ui/__shared/widgets/app_textfield.dart';
import 'package:memee_admin/ui/users/others/user_data_row.dart';
import 'package:memee_admin/ui/users/dialog/user_detailed_dialog.dart';

import '../../blocs/users/users_cubit.dart';
import '../../core/initializer/app_di_registration.dart';
import '../../models/user_model.dart';
import '../__shared/dialog/detailed_dialog.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator.get<UserCubit>(),
      child: _UserWidget(),
    );
  }
}

class _UserWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  final dataColumnHeaders = [
    'ID',
    'UserName',
    'Email',
    'Address',
    'PhoneNumber',
    'Verifer',
    'Status',
  ];

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Stack(
      children: [
        Positioned(
          right: 16.w,
          bottom: 48.h,
          child: FloatingActionButton(
            onPressed: () {
              showDetailedDialog(context, child: const UserDetailed());
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
                                  .importExcel<UserModel>();
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
                              if (userCubit.state is UsersSuccess) {
                                ctx
                                    .read<ExportImportCubit>()
                                    .exportExcel<UserModel>(
                                      data: (userCubit.state as UsersSuccess)
                                          .users,
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
                child: BlocBuilder<UserCubit, UsersState>(
                  bloc: userCubit..fetchUsers(),
                  builder: (context, state) {
                    if (state is UsersLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is UsersFailure) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is UsersSuccess) {
                      return DataTable(
                        showCheckboxColumn: false,
                        columns: dataColumnHeaders
                            .map(
                              (dch) => DataColumn(
                                label: Text(
                                  dch,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            )
                            .toList(),
                        rows: state.users.map((user) {
                          return userDataRow(context, user);
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

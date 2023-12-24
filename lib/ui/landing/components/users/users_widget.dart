import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memee_admin/blocs/export_import/export_import_cubit.dart';
import 'package:memee_admin/core/shared/app_column.dart';
import 'package:memee_admin/core/shared/app_strings.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';
import 'package:memee_admin/ui/landing/components/users/data-row/user_data_row.dart';
import 'package:memee_admin/ui/landing/components/users/widgets/user_detailed_widget.dart';

import '../../../../blocs/users/users_cubit.dart';
import '../../../../core/initializer/app_di_registration.dart';
import '../../../../models/user_model.dart';
import '../../../__shared/dialog/detailed_dialog.dart';
import '../../../__shared/widgets/data-table/app_data_table.dart';
import '../../../__shared/widgets/search_export_import_widget.dart';

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
  final _exportImport = locator.get<ExportImportCubit>();
  final _userCubit = locator.get<UserCubit>();

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
            SearchExportImportWidget(
              searchController: _searchController,
              searchLabel: '${AppStrings.search} ${AppStrings.user}',
              onExportPressed: () => _exportImport.exportCSV<UserModel>(),
              onImportPressed: () async {
                await _exportImport.importCSV<UserModel>();
                _userCubit.refresh();
              },
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
                      return AppDataTable(
                        headers: AppColumn.users,
                        items: state.users
                            .map((user) => userDataRow(context, user))
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

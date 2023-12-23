import 'package:flutter/material.dart';

class AppDataTable<T> extends StatelessWidget {
  final List<String> headers;
  final List<DataRow> items;

  const AppDataTable({
    super.key,
    required this.headers,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: headers
          .map(
            (dch) => DataColumn(
              label: Text(
                dch,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          )
          .toList(),
      rows: items,
    );
  }
}

class AppPaginatedDataTable<T> extends StatelessWidget {
  final List<String> headers;
  final List<DataRow> items;
  final int totalCount;
  final Function(int)? onPageChanged;

  const AppPaginatedDataTable({
    super.key,
    required this.headers,
    required this.items,
    required this.totalCount,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PaginatedDataTable(
            showCheckboxColumn: false,
            onPageChanged: onPageChanged,
            //initialFirstRowIndex: 1,
            rowsPerPage: items.length,
            columns: headers
                .map(
                  (dch) => DataColumn(
                    label: Text(
                      dch,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                )
                .toList(),
            source: AppDataTableSource(
              items: items,
              totalCount: totalCount,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDataTableSource extends DataTableSource {
  final List<DataRow> items;
  final int totalCount;

  AppDataTableSource({
    required this.items,
    required this.totalCount,
  });

  @override
  DataRow? getRow(int index) {
    return items[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}

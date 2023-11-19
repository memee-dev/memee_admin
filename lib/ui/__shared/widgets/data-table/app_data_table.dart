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

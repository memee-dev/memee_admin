import 'package:flutter/material.dart';

import '../../../../../models/order_model.dart';

DataRow orderDataRow(
  BuildContext context, {
  required OrderModel order,
}) {
  return DataRow(
    cells: [
      DataCell(Text(order.id)),
      DataCell(Text(order.userName)),
      DataCell(Text(order.productName)),
      DataCell(Text(order.categoryName)),
      DataCell(Text(order.paymentStatus)),
      DataCell(Text(order.orderStatus)),
    ],
  );
}

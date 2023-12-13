import 'package:flutter/material.dart';

import '../../../../../models/order_model.dart';

DataRow orderDataRow(
  BuildContext context, {
  required OrderModel order,
}) {
  return DataRow(
    cells: [
      DataCell(Text(order.id)),
      DataCell(Text(order.paymentId)),
      DataCell(Text(order.orderStatus)),
      DataCell(Text(order.orderedTime.toString())),
    ],
  );
}

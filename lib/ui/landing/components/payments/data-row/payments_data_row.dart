import 'package:flutter/material.dart';

import '../../../../../models/payment_model.dart';

DataRow paymentDataRow(
  BuildContext context, {
  required PaymentModel payment,
}) {
  return DataRow(
    cells: [
      DataCell(Text(payment.id)),
      DataCell(Text(payment.orderId)),
      DataCell(Text(payment.userName)),
      DataCell(Text(payment.dlName)),
      DataCell(Text(payment.amount)),
      DataCell(Text(payment.paymentStatus)),
    ],
  );
}

import 'package:intl/intl.dart';

extension Template on DateTime {
  String formatDateTime({String format = 'dd/MMM yyyy h:mm a'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this);
  }
}

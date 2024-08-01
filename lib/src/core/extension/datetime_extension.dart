import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormatedString([String formate = 'yyyy-MM-dd']) {
    return DateFormat(formate).format(this);
  }
}

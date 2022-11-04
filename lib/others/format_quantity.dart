// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///12.50 => 12.5
///12.00 => 12
///120 => 120
///12.535656 => 12.53
String formatQuantity(double? v) {
  if (v == null) return '';
  NumberFormat formatter = NumberFormat();
  formatter.minimumFractionDigits = 0;
  formatter.maximumFractionDigits = 2;
  return formatter.format(v);
}

import 'package:intl/intl.dart';
class FormatCurrency {
  static String formatCurrency(num amount) {
    final NumberFormat formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }
}

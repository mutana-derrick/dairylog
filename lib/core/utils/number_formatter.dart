import 'package:intl/intl.dart';

/// Utility class for formatting numbers, prices, and quantities.
class NumberFormatter {
  /// Formats a double value with two decimal places (e.g., 1234.50 → "1,234.50")
  static String formatDecimal(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  /// Formats integers with thousands separator (e.g., 1234 → "1,234")
  static String formatInt(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  /// Formats currency with symbol (e.g., RWF 1,234.50)
  static String formatCurrency(double value, {String symbol = 'RWF'}) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: symbol, decimalDigits: 0);
    return formatter.format(value);
  }

  /// Formats quantities (e.g., 1234.5 → "1,234.5 L")
  static String formatLiters(double value) {
    final formatter = NumberFormat('#,##0.0');
    return '${formatter.format(value)} L';
  }
}

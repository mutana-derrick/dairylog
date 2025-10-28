import 'package:intl/intl.dart';

/// Utility class for formatting dates consistently throughout the app.
class DateFormatter {
  // Example: "25 Oct 2025"
  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Example: "Saturday, 25 October 2025"
  static String formatLongDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy').format(date);
  }

  // Example: "14:35"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Example: "25/10/2025 14:35"
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Example: "Oct 25"
  static String formatMonthDay(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  // Example: "2025-10-25" (ISO-style)
  static String formatIso(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

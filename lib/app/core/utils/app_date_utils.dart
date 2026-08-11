import 'package:intl/intl.dart';

class AppDateUtils {
  static DateTime parse(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      if (value is DateTime) return value.toLocal();
      if (value is String) {
        // Handle various string formats
        final parsed = DateTime.parse(value);
        // If it doesn't have a timezone indicator, assume it's UTC and convert to local
        // (This depends on server behavior, but commonly APIs return UTC)
        if (!value.endsWith('Z') && !value.contains('+')) {
          return parsed.toLocal();
        }
        return parsed.toLocal();
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date.toLocal());
  }

  static String formatTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('hh:mm a').format(date.toLocal());
  }

  static String formatForDisplay(DateTime? date, String pattern) {
    if (date == null) return 'N/A';
    return DateFormat(pattern).format(date.toLocal());
  }
}

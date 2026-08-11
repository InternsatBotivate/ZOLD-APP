import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static const List<String> _sensitiveKeys = [
    'password',
    'otp',
    'token',
    'access_token',
    'refresh_token',
    'jwt',
    'secret',
    'razorpay_secret',
    'card_number',
    'cvv',
    'upi_id',
    'Authorization',
  ];

  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(_filter(message), error: error, stackTrace: stackTrace);
  }

  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(_filter(message), error: error, stackTrace: stackTrace);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(_filter(message), error: error, stackTrace: stackTrace);
    if (kReleaseMode && error != null) {
      debugPrint('PRODUCTION ERROR: $message | $error');
    }
  }

  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(_filter(message), error: error, stackTrace: stackTrace);
  }

  static String _filter(String message) {
    String filtered = message;
    for (final key in _sensitiveKeys) {
      // Regex to find "key": "value" or key=value and mask it
      final regExp = RegExp(
        '$key["\']?\\s*[:=]\\s*["\']?([^"\'\\s,{}]+)["\']?',
        caseSensitive: false,
      );
      filtered = filtered.replaceAllMapped(regExp, (match) {
        return '${match.group(0)?.split(RegExp('[:=]'))[0]}: [MASKED]';
      });
    }
    return filtered;
  }

  static Map<String, dynamic> filterMap(Map<String, dynamic> data) {
    final Map<String, dynamic> filtered = Map.from(data);
    filtered.forEach((key, value) {
      if (_sensitiveKeys.any((sk) => key.toLowerCase().contains(sk.toLowerCase()))) {
        filtered[key] = '[MASKED]';
      } else if (value is Map<String, dynamic>) {
        filtered[key] = filterMap(value);
      } else if (value is List) {
        filtered[key] = value.map((e) => e is Map<String, dynamic> ? filterMap(e) : e).toList();
      }
    });
    return filtered;
  }
}

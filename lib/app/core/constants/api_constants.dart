import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String _get(String key, String defaultValue) {
    try {
      if (!dotenv.isInitialized) return defaultValue;
      return dotenv.env[key] ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static String get baseUrl => _get('BASE_URL', '');
  static int get connectTimeout =>
      int.tryParse(_get('CONNECT_TIMEOUT', '30000')) ?? 30000;
  static int get receiveTimeout =>
      int.tryParse(_get('RECEIVE_TIMEOUT', '30000')) ?? 30000;
  static String get razorpayKey => _get('RAZORPAY_KEY', '');
  static String get riskDisclosurePdfUrl => _get('RISK_DISCLOSURE_PDF_URL', '');
}

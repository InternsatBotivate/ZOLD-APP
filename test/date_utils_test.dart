import 'package:flutter_test/flutter_test.dart';
import 'package:zold_gold/app/core/utils/app_date_utils.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('parse handles UTC string correctly', () {
      final utcString = "2023-10-27T10:00:00Z";
      final result = AppDateUtils.parse(utcString);
      expect(result.isUtc, false); // Should be converted to local
      expect(result.hour, isNot(10)); // Assuming test runner isn't in UTC
    });

    test('parse handles local string correctly', () {
      final localString = "2023-10-27T10:00:00";
      final result = AppDateUtils.parse(localString);
      expect(result.hour, 10);
    });

    test('formatDate returns expected format', () {
      final date = DateTime(2023, 10, 27);
      expect(AppDateUtils.formatDate(date), "27 Oct 2023");
    });

    test('formatDateTime returns expected format', () {
      final date = DateTime(2023, 10, 27, 14, 30);
      expect(AppDateUtils.formatDateTime(date), "27 Oct 2023, 02:30 PM");
    });
  });
}

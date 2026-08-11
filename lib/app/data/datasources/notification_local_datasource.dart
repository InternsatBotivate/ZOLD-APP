import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_models.dart';

abstract class NotificationLocalDataSource {
  Future<NotificationSettings?> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettings settings);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const String _settingsKey = 'notification_settings';

  @override
  Future<NotificationSettings?> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString != null) {
      try {
        return NotificationSettings.fromJson(jsonDecode(jsonString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}

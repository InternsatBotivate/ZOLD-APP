import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  late SharedPreferences _prefs;
  static const String _key = 'theme_mode';

  Future<ThemeService> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs.getString(_key);

    if (savedTheme != null) {
      _themeMode.value = _parseThemeMode(savedTheme);
    } else {
      _themeMode.value = ThemeMode.system;
    }

    return this;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _prefs.setString(_key, mode.toString());
  }

  ThemeMode _parseThemeMode(String value) {
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => ThemeMode.system,
    );
  }

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return themeMode == ThemeMode.dark;
  }
}

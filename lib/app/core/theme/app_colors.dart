import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Constant across themes)
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF5E6A3);
  static const Color darkGold = Color(0xFFB8960C);
  static const Color maroonAccent = Color(0xFF8B2942);

  // Core Theme Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF09090B);
  static const Color backgroundDarkSecondary = Color(0xFF18181B);

  // Light Theme Colors
  static const Color bgLight = Color(0xFFFAFAFA);
  static const Color bgLightSecondary = Color(0xFFF9FAFB);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF09090B);
  static const Color textSecondaryLight = Color(0xFF71717A);
  static const Color textMutedLight = Color(0xFFA1A1AA);
  static const Color borderLight = Color(0xFFE4E4E7);

  // Dark Theme Colors
  static const Color bgDark = Color(0xFF09090B);
  static const Color bgDarkSecondary = Color(0xFF18181B);
  static const Color surfaceDark = Color(0xFF18181B);
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color textMutedDark = Color(0xFF71717A);
  static const Color borderDark = Color(0xFF27272A);

  // Status Colors
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFCA8A04);
  static const Color info = Color(0xFF3B82F6);

  // Auth & Special Gradients
  static const Color authGradientStart = Color(0xFF3D3066);
  static const Color authGradientEnd = Color(0xFF8B7FA8);

  // Legacy/Compatibility Aliases (Deprecated - use Theme.of(context) instead)
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color cardBg = Colors.white;
  static const Color cardBorder = Color(0xFFF0F0F0);
  static const Color background = Color(0xFFFFF9E8);
  static const Color foreground = Color(0xFF1A1A1A);

  // SIP & Calculator
  static const Color sipHeaderStart = Color(0xFF3D3066);
  static const Color sipHeaderEnd = Color(0xFF5C4E7F);
  static const Color sipBgLight = Color(0xFFFDF8E8);
  static const Color sipRadialStart = Color(0xFFFDF7DE);
  static const Color sipRadialMid = Color(0xFFF6E7B8);
  static const Color sipRadialEnd = Color(0xFFEDD28D);
  static const Color sipBorder = Color(0xFFE4CD8E);
  static const Color sipTextGold = Color(0xFF5A4A1A);
  static const Color sipTextDark = Color(0xFF3D2F0A);
}

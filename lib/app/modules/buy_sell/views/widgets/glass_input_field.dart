import 'dart:ui';
import 'package:flutter/material.dart';

class GlassInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? prefixText;
  final String? suffixText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const GlassInputField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixText,
    this.suffixText,
    this.keyboardType = TextInputType.number,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? theme.colorScheme.primary : const Color(0xFF5A4A1A),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surface.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixText: prefixText != null ? '$prefixText ' : null,
                  suffixText: suffixText,
                  prefixStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xFF5A4A1A),
                  ),
                  suffixStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xFF5A4A1A),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

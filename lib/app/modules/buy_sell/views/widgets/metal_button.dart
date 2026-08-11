import 'package:flutter/material.dart';

class MetalButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isGold;
  final bool isLoading;

  const MetalButton({
    super.key,
    required this.text,
    this.onTap,
    this.isGold = true,
    this.isLoading = false,
  });

  @override
  State<MetalButton> createState() => _MetalButtonState();
}

class _MetalButtonState extends State<MetalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.onTap != null && !widget.isLoading;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => _controller.reverse() : null,
        onTapUp: isEnabled ? (_) => _controller.forward() : null,
        onTapCancel: isEnabled ? () => _controller.forward() : null,
        onTap: isEnabled ? widget.onTap : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: widget.isGold
                  ? (isDark
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              const Color(0xFFB8960C),
                              theme.colorScheme.primary,
                            ],
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFFE0BF6A),
                              Color(0xFF8B6B00),
                              Color(0xFFE0BF6A),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ))
                  : (isDark
                        ? const LinearGradient(
                            colors: [
                              Color(0xFFB0B8C6),
                              Color(0xFF8A94A8),
                              Color(0xFFB0B8C6),
                            ],
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFFCBD5E1),
                              Color(0xFF64748B),
                              Color(0xFFCBD5E1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color:
                            (widget.isGold
                                    ? (isDark
                                          ? theme.colorScheme.primary
                                          : const Color(0xFF8B6B00))
                                    : (isDark
                                          ? const Color(0xFFB0B8C6)
                                          : const Color(0xFF64748B)))
                                .withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: widget.isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: isDark ? Colors.black : Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.text.toUpperCase(),
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

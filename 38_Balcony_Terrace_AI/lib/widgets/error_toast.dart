// lib/widgets/error_toast.dart
// Error/success toast messages with auto-dismiss

import 'package:flutter/material.dart';
import '../theme/terrace_theme.dart';
import 'glass_card.dart';

class ErrorToast {
  ErrorToast._();

  static OverlayEntry? _currentOverlay;

  /// Show error toast message
  static void show(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.error_outline,
      iconColor: ShoeAIColors.error,
      borderColor: ShoeAIColors.error,
    );
  }

  /// Show success toast message
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      iconColor: ShoeAIColors.success,
      borderColor: ShoeAIColors.success,
    );
  }

  /// Show info toast message
  static void showInfo(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.info_outline,
      iconColor: ShoeAIColors.leatherTan,
      borderColor: ShoeAIColors.leatherTan,
    );
  }

  static void _showToast(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
  }) {
    // Remove existing toast if any
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon,
        iconColor: iconColor,
        borderColor: borderColor,
        onDismiss: () {
          overlayEntry.remove();
          if (_currentOverlay == overlayEntry) {
            _currentOverlay = null;
          }
        },
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (_currentOverlay == overlayEntry) {
        overlayEntry.remove();
        _currentOverlay = null;
      }
    });
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.onDismiss,
  });

  final String message;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ShoeAIMotion.standard,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ShoeAIMotion.emphasizedEasing,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + ShoeAISpacing.base,
      left: ShoeAISpacing.base,
      right: ShoeAISpacing.base,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: widget.onDismiss,
            child: GlassCard(
              borderRadius: ShoeAIRadii.cardRadius,
              showShadow: true,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: widget.borderColor,
                      width: 4,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: ShoeAISpacing.md,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 24,
                    ),
                    const SizedBox(width: ShoeAISpacing.md),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: ShoeAIText.body.copyWith(
                          color: ShoeAIColors.canvasWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: ShoeAISpacing.sm),
                    Icon(
                      Icons.close,
                      color: ShoeAIColors.canvasWhite.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

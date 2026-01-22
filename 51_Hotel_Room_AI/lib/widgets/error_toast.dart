// lib/widgets/error_toast.dart
// Error/success toast messages with auto-dismiss
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';
import 'glass_card.dart';

class ErrorToast {
  ErrorToast._();

  static OverlayEntry? _currentOverlay;

  static void show(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.error_outline,
      iconColor: HotelAIColors.error,
      borderColor: HotelAIColors.error,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      iconColor: HotelAIColors.success,
      borderColor: HotelAIColors.success,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.info_outline,
      iconColor: HotelAIColors.primary,
      borderColor: HotelAIColors.primary,
    );
  }

  static void _showToast(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
  }) {
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
      duration: HotelAIMotion.standard,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: HotelAIMotion.emphasizedEasing,
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
      top: MediaQuery.of(context).padding.top + HotelAISpacing.base,
      left: HotelAISpacing.base,
      right: HotelAISpacing.base,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: widget.onDismiss,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: HotelAIColors.bg1,
                borderRadius: HotelAIRadii.mediumRadius,
                boxShadow: HotelAIShadows.floating,
                border: Border.all(color: HotelAIColors.line),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(widget.icon, color: widget.iconColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: HotelAIText.body,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.close, color: HotelAIColors.muted, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

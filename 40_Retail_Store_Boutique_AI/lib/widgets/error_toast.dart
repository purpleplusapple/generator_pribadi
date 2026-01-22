// lib/widgets/error_toast.dart
// Error/success toast messages with auto-dismiss

import 'package:flutter/material.dart';
import '../theme/boutique_theme.dart';
import 'glass_card.dart';

class ErrorToast {
  ErrorToast._();
  static OverlayEntry? _currentOverlay;

  static void show(BuildContext context, String message) => _showToast(context, message: message, icon: Icons.error_outline, color: BoutiqueColors.danger);
  static void showSuccess(BuildContext context, String message) => _showToast(context, message: message, icon: Icons.check_circle_outline, color: BoutiqueColors.success);
  static void showInfo(BuildContext context, String message) => _showToast(context, message: message, icon: Icons.info_outline, color: BoutiqueColors.primary);

  static void _showToast(BuildContext context, {required String message, required IconData icon, required Color color}) {
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: message, icon: icon, color: color, onDismiss: () { overlayEntry.remove(); if (_currentOverlay == overlayEntry) _currentOverlay = null; }),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 4), () { if (_currentOverlay == overlayEntry) { overlayEntry.remove(); _currentOverlay = null; }});
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.message, required this.icon, required this.color, required this.onDismiss});
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback onDismiss;
  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..forward();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16, right: 16,
      child: FadeTransition(
        opacity: _controller,
        child: GestureDetector(
          onTap: widget.onDismiss,
          child: GlassCard(
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: widget.color, width: 4)),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: widget.color),
                  const SizedBox(width: 12),
                  Expanded(child: Text(widget.message, style: BoutiqueText.body)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

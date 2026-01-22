// lib/widgets/error_boundary.dart
// Error handling wrapper widget
// Option A: Boutique Linen

import 'package:flutter/material.dart';
import '../theme/hotel_room_ai_theme.dart';
import 'gradient_button.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.onRetry,
    this.fallbackMessage,
  });

  final Widget child;
  final VoidCallback? onRetry;
  final String? fallbackMessage;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorUI();
    }
    return widget.child;
  }

  Widget _buildErrorUI() {
    final isDebug = kDebugMode;
    final message = widget.fallbackMessage ??
        'Something went wrong. Please try again.';

    return Container(
      color: HotelAIColors.bg0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(HotelAISpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
               color: HotelAIColors.bg1,
               borderRadius: HotelAIRadii.mediumRadius,
               boxShadow: HotelAIShadows.soft,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 64, color: HotelAIColors.error),
                const SizedBox(height: 24),
                Text('Oops!', style: HotelAIText.h2),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: HotelAIColors.bg0,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: HotelAIColors.error),
                    ),
                    child: Text(
                      _error.toString(),
                      style: HotelAIText.caption.copyWith(
                        color: HotelAIColors.error,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      label: 'Try Again',
                      onPressed: () {
                        setState(() => _error = null);
                        widget.onRetry?.call();
                      },
                      icon: Icons.refresh,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const kDebugMode = bool.fromEnvironment('dart.vm.product') == false;

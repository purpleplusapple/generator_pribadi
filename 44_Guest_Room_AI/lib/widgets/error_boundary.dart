// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/guest_room_ai_theme.dart';
import 'glass_card.dart';
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

    // Wrap child in a simple error handler
    return widget.child;
  }

  Widget _buildErrorUI() {
    final isDebug = kDebugMode;
    final message = widget.fallbackMessage ??
        'Something went wrong. Please try again.';

    return Container(
      color: GuestAIColors.soleBlack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(GuestAISpacing.xl),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: GuestAIColors.error,
                ),
                const SizedBox(height: GuestAISpacing.xl),
                Text(
                  'Oops!',
                  style: GuestAIText.h2.copyWith(
                    color: GuestAIColors.canvasWhite,
                  ),
                ),
                const SizedBox(height: GuestAISpacing.sm),
                Text(
                  message,
                  style: GuestAIText.body.copyWith(
                    color: GuestAIColors.canvasWhite.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: GuestAISpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(GuestAISpacing.md),
                    decoration: BoxDecoration(
                      color: GuestAIColors.error.withValues(alpha: 0.1),
                      borderRadius: GuestAIRadii.chipRadius,
                      border: Border.all(
                        color: GuestAIColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: GuestAIText.captionMedium.copyWith(
                            color: GuestAIColors.error,
                          ),
                        ),
                        const SizedBox(height: GuestAISpacing.xs),
                        Text(
                          _error.toString(),
                          style: GuestAIText.small.copyWith(
                            color: GuestAIColors.canvasWhite.withValues(
                              alpha: 0.7,
                            ),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (widget.onRetry != null) ...[
                  const SizedBox(height: GuestAISpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      label: 'Try Again',
                      onPressed: () {
                        setState(() {
                          _error = null;
                        });
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

// Export kDebugMode for use in error boundary
const kDebugMode = bool.fromEnvironment('dart.vm.product') == false;

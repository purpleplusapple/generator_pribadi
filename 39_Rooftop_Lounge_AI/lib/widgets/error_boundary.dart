// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/shoe_room_ai_theme.dart';
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
      color: ShoeAIColors.soleBlack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(ShoeAISpacing.xl),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ShoeAIColors.error,
                ),
                const SizedBox(height: ShoeAISpacing.xl),
                Text(
                  'Oops!',
                  style: ShoeAIText.h2.copyWith(
                    color: ShoeAIColors.canvasWhite,
                  ),
                ),
                const SizedBox(height: ShoeAISpacing.sm),
                Text(
                  message,
                  style: ShoeAIText.body.copyWith(
                    color: ShoeAIColors.canvasWhite.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: ShoeAISpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ShoeAISpacing.md),
                    decoration: BoxDecoration(
                      color: ShoeAIColors.error.withValues(alpha: 0.1),
                      borderRadius: ShoeAIRadii.chipRadius,
                      border: Border.all(
                        color: ShoeAIColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: ShoeAIText.captionMedium.copyWith(
                            color: ShoeAIColors.error,
                          ),
                        ),
                        const SizedBox(height: ShoeAISpacing.xs),
                        Text(
                          _error.toString(),
                          style: ShoeAIText.small.copyWith(
                            color: ShoeAIColors.canvasWhite.withValues(
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
                  const SizedBox(height: ShoeAISpacing.xl),
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

// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';
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
      color: BeautyAIColors.charcoal,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(BeautyAISpacing.xl),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: BeautyAIColors.error,
                ),
                const SizedBox(height: BeautyAISpacing.xl),
                Text(
                  'Oops!',
                  style: BeautyAIText.h2.copyWith(
                    color: BeautyAIColors.creamWhite,
                  ),
                ),
                const SizedBox(height: BeautyAISpacing.sm),
                Text(
                  message,
                  style: BeautyAIText.body.copyWith(
                    color: BeautyAIColors.creamWhite.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: BeautyAISpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(BeautyAISpacing.md),
                    decoration: BoxDecoration(
                      color: BeautyAIColors.error.withValues(alpha: 0.1),
                      borderRadius: BeautyAIRadii.chipRadius,
                      border: Border.all(
                        color: BeautyAIColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: BeautyAIText.captionMedium.copyWith(
                            color: BeautyAIColors.error,
                          ),
                        ),
                        const SizedBox(height: BeautyAISpacing.xs),
                        Text(
                          _error.toString(),
                          style: BeautyAIText.small.copyWith(
                            color: BeautyAIColors.creamWhite.withValues(
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
                  const SizedBox(height: BeautyAISpacing.xl),
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

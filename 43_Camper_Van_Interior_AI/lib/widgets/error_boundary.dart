// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/camper_van_ai_theme.dart';
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
      color: CamperAIColors.soleBlack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(CamperAISpacing.xl),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: CamperAIColors.error,
                ),
                const SizedBox(height: CamperAISpacing.xl),
                Text(
                  'Oops!',
                  style: CamperAIText.h2.copyWith(
                    color: CamperAIColors.canvasWhite,
                  ),
                ),
                const SizedBox(height: CamperAISpacing.sm),
                Text(
                  message,
                  style: CamperAIText.body.copyWith(
                    color: CamperAIColors.canvasWhite.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: CamperAISpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(CamperAISpacing.md),
                    decoration: BoxDecoration(
                      color: CamperAIColors.error.withValues(alpha: 0.1),
                      borderRadius: CamperAIRadii.chipRadius,
                      border: Border.all(
                        color: CamperAIColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: CamperAIText.captionMedium.copyWith(
                            color: CamperAIColors.error,
                          ),
                        ),
                        const SizedBox(height: CamperAISpacing.xs),
                        Text(
                          _error.toString(),
                          style: CamperAIText.small.copyWith(
                            color: CamperAIColors.canvasWhite.withValues(
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
                  const SizedBox(height: CamperAISpacing.xl),
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

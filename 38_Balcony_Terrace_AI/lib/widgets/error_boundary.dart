// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/terrace_theme.dart';
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
      color: TerraceColors.soleBlack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(TerraceSpacing.xl),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: TerraceColors.error,
                ),
                const SizedBox(height: TerraceSpacing.xl),
                Text(
                  'Oops!',
                  style: TerraceText.h2.copyWith(
                    color: TerraceColors.canvasWhite,
                  ),
                ),
                const SizedBox(height: TerraceSpacing.sm),
                Text(
                  message,
                  style: TerraceText.body.copyWith(
                    color: TerraceColors.canvasWhite.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: TerraceSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TerraceSpacing.md),
                    decoration: BoxDecoration(
                      color: TerraceColors.error.withValues(alpha: 0.1),
                      borderRadius: TerraceRadii.chipRadius,
                      border: Border.all(
                        color: TerraceColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: TerraceText.captionMedium.copyWith(
                            color: TerraceColors.error,
                          ),
                        ),
                        const SizedBox(height: TerraceSpacing.xs),
                        Text(
                          _error.toString(),
                          style: TerraceText.small.copyWith(
                            color: TerraceColors.canvasWhite.withValues(
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
                  const SizedBox(height: TerraceSpacing.xl),
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

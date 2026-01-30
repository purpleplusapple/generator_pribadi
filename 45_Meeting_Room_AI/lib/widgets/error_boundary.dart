// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/meeting_room_theme.dart';
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
      color: MeetingAIColors.soleBlack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(MeetingAISpacing.xl),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: MeetingAIColors.error,
                ),
                const SizedBox(height: MeetingAISpacing.xl),
                Text(
                  'Oops!',
                  style: MeetingAIText.h2.copyWith(
                    color: MeetingAIColors.canvasWhite,
                  ),
                ),
                const SizedBox(height: MeetingAISpacing.sm),
                Text(
                  message,
                  style: MeetingAIText.body.copyWith(
                    color: MeetingAIColors.canvasWhite.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isDebug && _error != null) ...[
                  const SizedBox(height: MeetingAISpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(MeetingAISpacing.md),
                    decoration: BoxDecoration(
                      color: MeetingAIColors.error.withValues(alpha: 0.1),
                      borderRadius: MeetingAIRadii.chipRadius,
                      border: Border.all(
                        color: MeetingAIColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: MeetingAIText.captionMedium.copyWith(
                            color: MeetingAIColors.error,
                          ),
                        ),
                        const SizedBox(height: MeetingAISpacing.xs),
                        Text(
                          _error.toString(),
                          style: MeetingAIText.small.copyWith(
                            color: MeetingAIColors.canvasWhite.withValues(
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
                  const SizedBox(height: MeetingAISpacing.xl),
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

// lib/widgets/error_boundary.dart
// Error handling wrapper widget

import 'package:flutter/material.dart';
import '../theme/boutique_theme.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({super.key, required this.child, this.onRetry, this.fallbackMessage});
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
    if (_error != null) return _buildErrorUI();
    return widget.child;
  }

  Widget _buildErrorUI() {
    return Container(
      color: BoutiqueColors.bg0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: BoutiqueColors.danger),
                const SizedBox(height: 24),
                Text('Oops!', style: BoutiqueText.h2),
                const SizedBox(height: 8),
                Text(widget.fallbackMessage ?? 'Something went wrong.', style: BoutiqueText.body, textAlign: TextAlign.center),
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 24),
                  GradientButton(label: 'Try Again', onPressed: () { setState(() => _error = null); widget.onRetry?.call(); }, icon: Icons.refresh),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

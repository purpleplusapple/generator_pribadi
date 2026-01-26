// lib/widgets/loading_overlay.dart
// Full-screen loading indicator with optional message

import 'package:flutter/material.dart';
import '../theme/boutique_theme.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isVisible,
    this.message,
  });

  final bool isVisible;
  final String? message;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: BoutiqueColors.bg0.withValues(alpha: 0.9),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(BoutiqueColors.primary),
              ),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(message!, style: BoutiqueText.bodyMedium.copyWith(color: BoutiqueColors.ink0)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

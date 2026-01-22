// lib/widgets/loading_overlay.dart
// Full-screen loading indicator with optional message

import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

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
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: ClinicColors.soleBlack.withValues(alpha: 0.85),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ClinicColors.leatherTan,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: ClinicSpacing.xl),
                Text(
                  message!,
                  style: ClinicText.body.copyWith(
                    color: ClinicColors.canvasWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

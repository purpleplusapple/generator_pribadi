// lib/widgets/loading_overlay.dart
// Full-screen loading indicator with optional message

import 'package:flutter/material.dart';
import '../theme/camper_van_ai_theme.dart';

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
        color: CamperAIColors.soleBlack.withValues(alpha: 0.85),
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
                    CamperAIColors.leatherTan,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: CamperAISpacing.xl),
                Text(
                  message!,
                  style: CamperAIText.body.copyWith(
                    color: CamperAIColors.canvasWhite,
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

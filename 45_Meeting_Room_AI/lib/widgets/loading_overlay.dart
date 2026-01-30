// lib/widgets/loading_overlay.dart
// Full-screen loading indicator with optional message

import 'package:flutter/material.dart';
import '../theme/meeting_room_theme.dart';

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
        color: MeetingAIColors.soleBlack.withValues(alpha: 0.85),
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
                    MeetingAIColors.leatherTan,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: MeetingAISpacing.xl),
                Text(
                  message!,
                  style: MeetingAIText.body.copyWith(
                    color: MeetingAIColors.canvasWhite,
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

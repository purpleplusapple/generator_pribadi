import 'package:flutter/material.dart';
import '../theme/beauty_salon_ai_theme.dart';

class BeautySplitHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onNotificationTap;

  const BeautySplitHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BeautyAISpacing.lg,
        vertical: BeautyAISpacing.base,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Greeting + Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle.toUpperCase(),
                  style: BeautyAIText.caption.copyWith(
                    color: BeautyAIColors.muted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: BeautyAIText.h1.copyWith(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),

          // Right: Mini Card / Notification / Profile
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: BeautyAIColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BeautyAIColors.line),
                boxShadow: BeautyAIShadows.soft,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: BeautyAIColors.ink0,
                    size: 24,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: BeautyAIColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

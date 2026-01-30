import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class UploadTwoPanelGuidance extends StatelessWidget {
  final VoidCallback onUpload;

  const UploadTwoPanelGuidance({super.key, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Two panels
        Row(
          children: [
            Expanded(
              child: _buildGuidanceCard(
                'Good Photo',
                'Bright lighting, clear angles, tidy space.',
                'assets/onboarding/onboard_good.svg',
                true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGuidanceCard(
                'Avoid',
                'Dark rooms, extreme close-ups, people.',
                'assets/onboarding/onboard_bad.svg',
                false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Upload Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Take or Upload Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: StudyAIColors.primary,
              foregroundColor: StudyAIColors.bg0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuidanceCard(String title, String desc, String asset, bool isGood) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StudyAIColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGood ? StudyAIColors.success.withValues(alpha: 0.3) : StudyAIColors.danger.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: StudyAIText.h3.copyWith(
              color: isGood ? StudyAIColors.success : StudyAIColors.danger,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(asset, height: 80),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: StudyAIText.bodySmall.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

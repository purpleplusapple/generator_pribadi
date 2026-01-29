import 'package:flutter/material.dart';
import '../../theme/terrace_theme.dart';

class CreateBottomSheet extends StatelessWidget {
  final VoidCallback onStartWizard;

  const CreateBottomSheet({super.key, required this.onStartWizard});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TerraceColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: TerraceShadows.modal,
      ),
      padding: const EdgeInsets.all(TerraceSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TerraceColors.laceGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: TerraceSpacing.xl),
          Text('New Transformation', style: TerraceText.h2),
          const SizedBox(height: TerraceSpacing.sm),
          Text(
            'Upload a photo of your balcony or terrace to visualize new styles.',
            style: TerraceText.body.copyWith(color: TerraceColors.laceGray),
          ),
          const SizedBox(height: TerraceSpacing.xxl),
          _ActionTile(
            icon: Icons.camera_alt_outlined,
            title: 'Take Photo',
            subtitle: 'Use your camera',
            onTap: onStartWizard, // In real app, might pass source
          ),
          const SizedBox(height: TerraceSpacing.md),
          _ActionTile(
            icon: Icons.image_outlined,
            title: 'Select from Gallery',
            subtitle: 'Choose existing photo',
            onTap: onStartWizard,
          ),
          const SizedBox(height: TerraceSpacing.xxl),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TerraceSpacing.base),
        decoration: BoxDecoration(
          color: TerraceColors.bg1,
          borderRadius: BorderRadius.circular(TerraceTokens.radiusMedium),
          border: Border.all(
            color: TerraceColors.laceGray.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TerraceColors.primaryEmerald.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: TerraceColors.primaryEmerald),
            ),
            const SizedBox(width: TerraceSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TerraceText.bodySemiBold),
                Text(subtitle, style: TerraceText.caption),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: TerraceColors.laceGray),
          ],
        ),
      ),
    );
  }
}

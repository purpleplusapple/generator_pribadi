import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class UploadStepTwoPanel extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const UploadStepTwoPanel({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Panel 1: Action (Top 40%)
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Capture the Space",
                  style: StorageTheme.darkTheme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Ensure good lighting and capture floor-to-ceiling.",
                  style: StorageTheme.darkTheme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt_rounded,
                        label: "Camera",
                        onTap: onCameraTap,
                        primary: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.photo_library_rounded,
                        label: "Gallery",
                        onTap: onGalleryTap,
                        primary: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Panel 2: Guidance (Bottom 60%)
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: StorageColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              border: Border(top: BorderSide(color: StorageColors.line)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: StorageColors.accentAmber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "FRAMING GUIDE",
                      style: StorageTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: StorageColors.accentAmber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildGuideCard(
                          "Do This",
                          "assets/onboarding/guide_good.jpg",
                          StorageColors.success,
                          Icons.check_circle_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGuideCard(
                          "Avoid This",
                          "assets/onboarding/guide_bad.jpg",
                          StorageColors.danger,
                          Icons.cancel_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool primary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: primary ? StorageColors.primaryLime : StorageColors.surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primary ? StorageColors.primaryLime : StorageColors.line,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: primary ? Colors.black : StorageColors.ink0,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: primary ? Colors.black : StorageColors.ink0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(String title, String assetPath, Color color, IconData icon) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, _, __) => Container(color: StorageColors.bg1),
                ),
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                Center(
                  child: Icon(icon, color: color, size: 40),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

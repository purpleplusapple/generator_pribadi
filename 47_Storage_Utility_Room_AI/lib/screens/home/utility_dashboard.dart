import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';
import '../../widgets/dashboard/organize_score_header.dart';
import '../../widgets/dashboard/storage_systems_carousel.dart';
import '../../widgets/dashboard/zone_row_cards.dart';
import '../../widgets/dashboard/label_kit_mini_tiles.dart';

class UtilityDashboard extends StatelessWidget {
  final VoidCallback onQuickStartTap;

  const UtilityDashboard({super.key, required this.onQuickStartTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StorageColors.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: StorageColors.primaryLime,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warehouse_rounded, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              "STORAGE ROOM AI",
              style: StorageTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontFamily: 'Sora',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120), // Space for dock
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OrganizeScoreHeader(),
            const SizedBox(height: 24),
            const StorageSystemsCarousel(),
            const SizedBox(height: 24),
            const ZoneRowCards(),
            const SizedBox(height: 24),
            const LabelKitMiniTiles(),
            const SizedBox(height: 32),

            // Quick Start Inline
            GestureDetector(
              onTap: onQuickStartTap,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [StorageColors.surface2, StorageColors.surface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: StorageColors.primaryLime.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: StorageColors.bg0,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_a_photo_rounded, color: StorageColors.primaryLime),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Project",
                            style: StorageTheme.darkTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Start from camera or gallery",
                            style: StorageTheme.darkTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: StorageColors.muted),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

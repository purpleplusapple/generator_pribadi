import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

class ClinicQuickActionsRow extends StatelessWidget {
  const ClinicQuickActionsRow({
    super.key,
    required this.onNewDesignTap,
    required this.onRoomTypesTap,
    required this.onGuidelinesTap,
    required this.onFavoritesTap,
  });

  final VoidCallback onNewDesignTap;
  final VoidCallback onRoomTypesTap;
  final VoidCallback onGuidelinesTap;
  final VoidCallback onFavoritesTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildActionItem(
            context,
            icon: Icons.add_circle_outline_rounded,
            label: 'New Design',
            onTap: onNewDesignTap,
            isPrimary: true,
          ),
          const SizedBox(width: ClinicSpacing.base),
          _buildActionItem(
            context,
            icon: Icons.category_outlined,
            label: 'Room Types',
            onTap: onRoomTypesTap,
          ),
          const SizedBox(width: ClinicSpacing.base),
          _buildActionItem(
            context,
            icon: Icons.health_and_safety_outlined,
            label: 'Guidelines',
            onTap: onGuidelinesTap,
          ),
          const SizedBox(width: ClinicSpacing.base),
          _buildActionItem(
            context,
            icon: Icons.bookmark_border_rounded,
            label: 'Favorites',
            onTap: onFavoritesTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final color = isPrimary ? ClinicColors.primary : ClinicColors.ink1;
    final bg = isPrimary ? ClinicColors.primarySoft : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: ClinicRadius.mediumRadius,
              border: Border.all(
                color: isPrimary ? ClinicColors.primary.withValues(alpha: 0.3) : ClinicColors.line,
              ),
              boxShadow: ClinicShadows.card,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: ClinicText.small.copyWith(
              fontWeight: FontWeight.w600,
              color: ClinicColors.ink1,
            ),
          ),
        ],
      ),
    );
  }
}

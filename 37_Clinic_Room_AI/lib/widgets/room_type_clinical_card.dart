import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';
import 'clinical_card.dart';

class RoomTypeClinicalCard extends StatelessWidget {
  const RoomTypeClinicalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 180,
      child: ClinicalCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Background decoration (simple color block for now)
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: (color ?? ClinicColors.primary).withValues(alpha: 0.1),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(ClinicSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (color ?? ClinicColors.primary).withValues(alpha: 0.1),
                      borderRadius: ClinicRadius.smallRadius,
                    ),
                    child: Icon(
                      icon,
                      color: color ?? ClinicColors.primary,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: ClinicText.h3.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: ClinicText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

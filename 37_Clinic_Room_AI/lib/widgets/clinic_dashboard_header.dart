import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

class ClinicDashboardHeader extends StatelessWidget {
  const ClinicDashboardHeader({
    super.key,
    this.greeting = 'Clinic Planner',
    this.score = 85,
  });

  final String greeting;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ClinicSpacing.lg,
        vertical: ClinicSpacing.base,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: ClinicText.captionMedium.copyWith(color: ClinicColors.ink2),
              ),
              const SizedBox(height: 4),
              Text(
                greeting,
                style: ClinicText.h2.copyWith(color: ClinicColors.ink0),
              ),
            ],
          ),
          _buildReadinessBadge(),
        ],
      ),
    );
  }

  Widget _buildReadinessBadge() {
    return Container(
      padding: const EdgeInsets.all(ClinicSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ClinicRadius.largeRadius,
        border: Border.all(color: ClinicColors.line),
        boxShadow: ClinicShadows.card,
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4,
            backgroundColor: ClinicColors.bg0,
            color: ClinicColors.primary,
          ),
          const SizedBox(width: ClinicSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$score%',
                style: ClinicText.h3.copyWith(height: 1.0),
              ),
              Text(
                'Readiness',
                style: ClinicText.small.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

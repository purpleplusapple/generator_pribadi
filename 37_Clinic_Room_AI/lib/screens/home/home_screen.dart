import 'package:flutter/material.dart';
import '../../theme/clinic_theme.dart';
import '../../widgets/clinic_dashboard_header.dart';
import '../../widgets/clinic_quick_actions_row.dart';
import '../../widgets/room_type_clinical_card.dart';
import '../../widgets/clinical_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinicColors.bg0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: ClinicSpacing.huge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dashboard Header
              const ClinicDashboardHeader(
                greeting: 'Clinic Planner',
                score: 82,
              ),

              const SizedBox(height: ClinicSpacing.lg),

              // 2. Quick Actions
              ClinicQuickActionsRow(
                onNewDesignTap: () {
                  // Find parent RootShell or navigate
                  // For now, we will simulate tab switch or push
                  // Assuming logic handles this later
                  final tabController = DefaultTabController.of(context);
                  if (tabController != null) {
                    tabController.animateTo(1);
                  } else {
                     // Fallback if no tab controller (likely managed by RootShell state)
                     // We'll leave this to be hooked up or push a route
                  }
                },
                onRoomTypesTap: () {},
                onGuidelinesTap: () {},
                onFavoritesTap: () {},
              ),

              const SizedBox(height: ClinicSpacing.xl),

              // 3. Room Types Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clinical Room Types',
                      style: ClinicText.h3,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All', style: ClinicText.button.copyWith(color: ClinicColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ClinicSpacing.base),

              // Horizontal List
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg),
                  children: [
                    RoomTypeClinicalCard(
                      title: 'Examination Room',
                      subtitle: 'Standard Layout',
                      icon: Icons.monitor_heart_outlined,
                      color: ClinicColors.primary,
                      onTap: () {},
                    ),
                    const SizedBox(width: ClinicSpacing.base),
                    RoomTypeClinicalCard(
                      title: 'Waiting Area',
                      subtitle: 'Calm & Spacious',
                      icon: Icons.chair_outlined,
                      color: ClinicColors.accent,
                      onTap: () {},
                    ),
                    const SizedBox(width: ClinicSpacing.base),
                    RoomTypeClinicalCard(
                      title: 'Dental Suite',
                      subtitle: 'Ergonomic Flow',
                      icon: Icons.medical_services_outlined,
                      color: ClinicColors.success,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ClinicSpacing.xl),

              // 4. Guidelines Section (Vertical List)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg),
                child: Text(
                  'Hygiene & Layout Tips',
                  style: ClinicText.h3,
                ),
              ),
              const SizedBox(height: ClinicSpacing.base),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ClinicSpacing.lg),
                child: Column(
                  children: [
                    _buildGuidelineItem(
                      icon: Icons.light_mode_outlined,
                      title: 'Optimal Lighting',
                      desc: 'Ensure 500+ lux for examination areas.',
                    ),
                    const SizedBox(height: ClinicSpacing.base),
                    _buildGuidelineItem(
                      icon: Icons.cleaning_services_outlined,
                      title: 'Surface Materials',
                      desc: 'Use non-porous materials for easy sterilization.',
                    ),
                    const SizedBox(height: ClinicSpacing.base),
                    _buildGuidelineItem(
                      icon: Icons.accessibility_new_outlined,
                      title: 'Patient Flow',
                      desc: 'Design clear pathways to reduce cross-contamination.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return ClinicalCard(
      padding: const EdgeInsets.all(ClinicSpacing.base),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ClinicColors.bg0,
              borderRadius: ClinicRadius.smallRadius,
            ),
            child: Icon(icon, color: ClinicColors.ink1, size: 24),
          ),
          const SizedBox(width: ClinicSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ClinicText.bodySemiBold),
                Text(desc, style: ClinicText.caption),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: ClinicColors.ink2),
        ],
      ),
    );
  }
}

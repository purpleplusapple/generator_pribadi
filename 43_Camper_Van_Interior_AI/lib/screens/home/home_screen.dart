import 'package:flutter/material.dart';
import '../../theme/camper_theme.dart';
import 'widgets/van_studio_header.dart';
import 'widgets/signature_build_carousel.dart';
import 'widgets/zone_row_cards.dart';
import 'widgets/constraint_mini_controls.dart';
import '../wizard/wizard_screen.dart'; // We'll need this later

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CamperAIColors.soleBlack,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Bottom padding for dock
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VanStudioHeader(),
              const SizedBox(height: 32),

              const SignatureBuildCarousel(),
              const SizedBox(height: 32),

              const ZoneRowCards(),
              const SizedBox(height: 32),

              Text("Project Constraints", style: CamperAIText.h3),
              const SizedBox(height: 12),
              const ConstraintMiniControls(),

              const SizedBox(height: 32),
              _buildQuickStartCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStartCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const WizardScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CamperAIColors.leatherTan, CamperAIColors.primarySoft],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Start New Conversion",
                    style: CamperAIText.h3.copyWith(color: CamperAIColors.soleBlack)),
                  const SizedBox(height: 4),
                  Text("Upload photo & choose style",
                    style: CamperAIText.bodyMedium.copyWith(color: CamperAIColors.soleBlack.withOpacity(0.7))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CamperAIColors.soleBlack.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward, color: CamperAIColors.soleBlack),
            )
          ],
        ),
      ),
    );
  }
}

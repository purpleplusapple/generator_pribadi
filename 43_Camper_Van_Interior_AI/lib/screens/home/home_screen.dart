import 'package:flutter/material.dart';
import 'widgets/van_studio_header.dart';
import 'widgets/signature_build_carousel.dart';
import 'widgets/zone_row_cards.dart';
import 'widgets/constraint_mini_controls.dart';
import '../../theme/camper_tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120), // Space for dock
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const VanStudioHeader(),
              const SizedBox(height: 24),
              const SignatureBuildCarousel(),
              const ZoneRowCards(),
              const ConstraintMiniControls(),
              _buildQuickStart(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () {
          // In a real app, this would switch to the Wizard tab via state management
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tap the 'Build' hammer icon to start!")),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [CamperTokens.primary, CamperTokens.primarySoft],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(CamperTokens.radiusL),
            boxShadow: [
              BoxShadow(
                color: CamperTokens.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Start New Conversion", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  const Text("Upload photo & choose style", style: TextStyle(color: Colors.white70)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

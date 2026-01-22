import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/clinic_theme.dart';
import '../../../widgets/clinical_card.dart';
import '../../../widgets/primary_button.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({super.key, required this.controller});
  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showAfter = true;

  @override
  Widget build(BuildContext context) {
    final originalPath = widget.controller.selectedImagePath;
    final generatedPath = widget.controller.resultData?.generatedImagePath;

    if (originalPath == null || generatedPath == null) {
      return Center(child: Text('Error: Missing result data', style: ClinicText.body));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ClinicSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transformation', style: ClinicText.h2),
                  Text('Result Ready', style: ClinicText.caption),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Share.shareXFiles([XFile(generatedPath)], text: 'Check out my Clinic Room AI Design!'),
                    icon: Icon(Icons.share, color: ClinicColors.primary),
                  ),
                  IconButton(
                    onPressed: () => widget.controller.resetWizard(),
                    icon: Icon(Icons.close, color: ClinicColors.ink1),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: ClinicSpacing.lg),

          // Main Interactive View
          GestureDetector(
            onTap: () => setState(() => _showAfter = !_showAfter),
            child: ClinicalCard(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: ClinicRadius.mediumRadius,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Image.file(
                        File(_showAfter ? generatedPath : originalPath),
                        key: ValueKey(_showAfter),
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: ClinicShadows.floating,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggleOption('Before', !_showAfter),
                            _buildToggleOption('After', _showAfter),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: ClinicSpacing.xl),

          // Details Panel
          Text('Clinical Analysis', style: ClinicText.h3),
          const SizedBox(height: ClinicSpacing.md),
          _buildDetailItem(Icons.light_mode, 'Lighting Score', '92/100 (Excellent)'),
          _buildDetailItem(Icons.cleaning_services, 'Hygiene Layout', 'Optimized'),
          _buildDetailItem(Icons.chair, 'Furniture', 'Ergonomic Medical Grade'),

          const SizedBox(height: ClinicSpacing.xl),

          PrimaryButton(
            label: 'Start New Design',
            onPressed: () => widget.controller.resetWizard(),
            size: ButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _showAfter = (label == 'After')),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ClinicColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: ClinicText.small.copyWith(
            color: isActive ? Colors.white : ClinicColors.ink1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ClinicSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ClinicColors.bg0,
              borderRadius: ClinicRadius.smallRadius,
            ),
            child: Icon(icon, size: 20, color: ClinicColors.ink2),
          ),
          const SizedBox(width: ClinicSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ClinicText.caption),
              Text(value, style: ClinicText.bodySemiBold),
            ],
          ),
        ],
      ),
    );
  }
}

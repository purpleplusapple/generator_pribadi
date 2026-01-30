import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';
import '../../result/widgets/tap_compare_toggle.dart';
import '../../result/widgets/build_notes_panel.dart';
import '../wizard_controller.dart';

class ResultStep extends StatelessWidget {
  final WizardController controller;
  const ResultStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final generatedPath = controller.resultData?.generatedImagePath;
        final originalPath = controller.selectedImagePath;

        if (generatedPath == null || originalPath == null) {
           return Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Icon(Icons.broken_image, size: 48, color: CamperTokens.muted),
                 const SizedBox(height: 16),
                 const Text("No result generated yet.", style: TextStyle(color: CamperTokens.muted)),
                 TextButton(onPressed: controller.previousStep, child: const Text("Go Back"))
               ],
             ),
           );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
               // Compare Toggle
               Padding(
                 padding: const EdgeInsets.all(16),
                 child: TapOrSwipeCompareToggle(
                   beforeImage: originalPath,
                   afterImage: generatedPath
                 ),
               ),

               // Build Notes
               const Padding(
                 padding: EdgeInsets.symmetric(horizontal: 16),
                 child: BuildNotesPanel(),
               ),

               const SizedBox(height: 24),

               // Actions
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                    _ActionButton(Icons.save_alt, "Save", () {}),
                    _ActionButton(Icons.share_outlined, "Share", () {}),
                    _ActionButton(Icons.refresh, "Regenerate", () => controller.previousStep()),
                 ],
               ),

               const SizedBox(height: 24),

               ElevatedButton(
                 onPressed: controller.resetWizard,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: CamperTokens.primary,
                   foregroundColor: Colors.black,
                   padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                 ),
                 child: const Text("Start New Build"),
               )
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: CamperTokens.surface2,
          child: IconButton(icon: Icon(icon, color: CamperTokens.ink0), onPressed: onTap),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: CamperTokens.muted)),
      ],
    );
  }
}

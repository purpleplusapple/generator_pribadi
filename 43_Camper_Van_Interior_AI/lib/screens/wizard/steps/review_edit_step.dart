import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';
import '../wizard_controller.dart';
import '../../../data/camper_styles_data.dart';

class ReviewEditStep extends StatefulWidget {
  const ReviewEditStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<ReviewEditStep> createState() => _ReviewEditStepState();
}

class _ReviewEditStepState extends State<ReviewEditStep> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.controller.config.reviewNotes ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final imagePath = widget.controller.selectedImagePath;
        final styleId = widget.controller.selectedStyleId;
        final style = CamperStylesData.styles.firstWhere((s) => s.id == styleId, orElse: () => CamperStylesData.styles.first);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Text("Review Build Plan", style: Theme.of(context).textTheme.headlineMedium),
               const SizedBox(height: 16),

               // Image
               if (imagePath != null)
                 ClipRRect(
                   borderRadius: BorderRadius.circular(CamperTokens.radiusM),
                   child: Image.file(File(imagePath), height: 200, fit: BoxFit.cover),
                 ),

               const SizedBox(height: 16),

               // Style Summary
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(color: CamperTokens.surface, borderRadius: BorderRadius.circular(CamperTokens.radiusM)),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Style: ${style.name}", style: const TextStyle(fontWeight: FontWeight.bold, color: CamperTokens.ink0)),
                         TextButton(onPressed: widget.controller.previousStep, child: const Text("Change"))
                       ],
                     ),
                     const Divider(color: CamperTokens.line),
                     ...widget.controller.styleControlValues.entries.map((e) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: const TextStyle(color: CamperTokens.muted, fontSize: 12)),
                              Text(e.value.toString(), style: const TextStyle(color: CamperTokens.ink1, fontSize: 12)),
                            ],
                          ),
                        )
                     ).toList()
                   ],
                 ),
               ),

               const SizedBox(height: 24),
               ElevatedButton(
                 onPressed: widget.controller.nextStep,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: CamperTokens.primary,
                   foregroundColor: Colors.black,
                   padding: const EdgeInsets.all(16)
                 ),
                 child: const Text("Generate Layout"),
               )
            ],
          ),
        );
      },
    );
  }
}

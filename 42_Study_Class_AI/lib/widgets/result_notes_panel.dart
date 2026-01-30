import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultNotesPanel extends StatelessWidget {
  const ResultNotesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: StudyAIColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StudyAIColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sticky_note_2_outlined, color: StudyAIColors.primary),
              const SizedBox(width: 8),
              Text('Study Setup Notes', style: StudyAIText.h3),
            ],
          ),
          const SizedBox(height: 12),
          _buildNoteItem('Desk', 'Ergonomic height, cleared surface.'),
          _buildNoteItem('Lighting', 'Warm task light to reduce eye strain.'),
          _buildNoteItem('Storage', 'Vertical shelves utilized efficiently.'),
          _buildNoteItem('Noise', 'Acoustic panels or soft furnishings.'),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: StudyAIText.bodySmall,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: StudyAIColors.ink0),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

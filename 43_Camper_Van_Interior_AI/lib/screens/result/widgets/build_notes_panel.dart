import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';

class BuildNotesPanel extends StatelessWidget {
  const BuildNotesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CamperTokens.surface,
        borderRadius: BorderRadius.circular(CamperTokens.radiusL),
        border: Border.all(color: CamperTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: CamperTokens.ink0),
              const SizedBox(width: 12),
              Text("Build Specs", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          const _SpecRow("Bed Size", "Queen Short (60x75)"),
          const Divider(color: CamperTokens.line),
          const _SpecRow("Kitchen", "Galley + Induction"),
          const Divider(color: CamperTokens.line),
          const _SpecRow("Electrical", "400Ah Lithium"),
          const Divider(color: CamperTokens.line),
          const _SpecRow("Lighting", "Dimmable 3000K LED"),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  const _SpecRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: CamperTokens.muted)),
          Text(value, style: const TextStyle(color: CamperTokens.ink1, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

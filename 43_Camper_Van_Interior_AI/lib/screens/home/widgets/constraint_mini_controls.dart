import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';

class ConstraintMiniControls extends StatelessWidget {
  const ConstraintMiniControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CamperTokens.surface,
          borderRadius: BorderRadius.circular(CamperTokens.radiusM),
          border: Border.all(color: CamperTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Constraints", style: Theme.of(context).textTheme.titleMedium),
                Icon(Icons.tune, size: 16, color: CamperTokens.muted),
              ],
            ),
            const SizedBox(height: 16),
            _RowControl("Budget", "\$15k - \$30k"),
            const Divider(color: CamperTokens.line, height: 24),
            _RowControl("Van Size", "Sprinter 170"),
            const Divider(color: CamperTokens.line, height: 24),
            _RowControl("Off-Grid", "Medium (300Ah)"),
          ],
        ),
      ),
    );
  }
}

class _RowControl extends StatelessWidget {
  final String label;
  final String value;
  const _RowControl(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: CamperTokens.muted)),
        Text(value, style: const TextStyle(color: CamperTokens.ink0, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/camper_tokens.dart';

class VanStudioHeader extends StatelessWidget {
  const VanStudioHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your Van Layout", style: Theme.of(context).textTheme.displaySmall),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
                color: CamperTokens.ink1,
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _Chip("Solo", true),
              _Chip("Couple", false),
              _Chip("Family", false),
              _Chip("Work", false),
              _Chip("Pet", false),
            ],
          ),
        )
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _Chip(this.label, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? CamperTokens.primary : CamperTokens.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? CamperTokens.primary : CamperTokens.line),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : CamperTokens.ink0,
          fontWeight: FontWeight.w600,
        )
      ),
    );
  }
}

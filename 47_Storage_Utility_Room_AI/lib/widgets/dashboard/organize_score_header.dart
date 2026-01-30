import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class OrganizeScoreHeader extends StatelessWidget {
  const OrganizeScoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: StorageColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StorageColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Organization Score", style: StorageTheme.darkTheme.textTheme.headlineMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: StorageColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: StorageColors.primaryLime.withValues(alpha: 0.3)),
                ),
                child: const Text("PRO LEVEL", style: TextStyle(color: StorageColors.primaryLime, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIndicator("Shelves", 0.8),
              _buildIndicator("Labels", 0.4),
              _buildIndicator("Floor", 0.6),
              _buildIndicator("Access", 0.9),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(String label, double value) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 8,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: StorageColors.bg1,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                heightFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: value > 0.7 ? StorageColors.primaryLime : StorageColors.accentAmber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: StorageTheme.darkTheme.textTheme.bodySmall?.copyWith(fontSize: 10)),
      ],
    );
  }
}

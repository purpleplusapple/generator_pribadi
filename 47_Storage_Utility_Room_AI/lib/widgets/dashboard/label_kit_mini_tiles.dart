import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class LabelKitMiniTiles extends StatelessWidget {
  const LabelKitMiniTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text("Label Kit", style: StorageTheme.darkTheme.textTheme.headlineSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildTile(Icons.label_outline_rounded, "Bin Labels"),
              _buildTile(Icons.qr_code_rounded, "Smart QR"),
              _buildTile(Icons.format_list_numbered_rounded, "Inventory Tags"),
              _buildTile(Icons.warning_amber_rounded, "Safety Signs"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: StorageColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StorageColors.line),
      ),
      child: Row(
        children: [
          Icon(icon, color: StorageColors.primaryLime, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: StorageTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

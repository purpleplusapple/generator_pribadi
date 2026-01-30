import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';

class OrganizationNotesPanel extends StatelessWidget {
  const OrganizationNotesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: StorageColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StorageColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_rounded, color: StorageColors.primaryLime, size: 20),
              const SizedBox(width: 8),
              Text(
                "ORGANIZATION NOTES",
                style: StorageTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.2,
                  color: StorageColors.primaryLime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNoteItem("Zoning", "Separated cleaning vs pantry zones for safety."),
          _buildNoteItem("Clearance", "Maintained 36\" path for appliance access."),
          _buildNoteItem("Verticality", "Utilized full height for seasonal bins."),
          _buildNoteItem("Labels", "Recommended QR system for opaque bins."),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: StorageColors.muted,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: StorageColors.ink0,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/screens/wizard/steps/result_step.dart
// Result step with generated image and meeting readiness notes

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/meeting_room_theme.dart';
import '../../../theme/meeting_tokens.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/error_toast.dart';
import '../wizard_controller.dart';

class ResultStep extends StatefulWidget {
  const ResultStep({
    super.key,
    required this.controller,
  });

  final WizardController controller;

  @override
  State<ResultStep> createState() => _ResultStepState();
}

class _ResultStepState extends State<ResultStep> {
  bool _showBefore = false;

  Future<void> _saveToGallery() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ?? widget.controller.selectedImagePath;
    if (imagePath == null) return;

    try {
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (mounted) ErrorToast.showSuccess(context, 'Saved to gallery!');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to save');
    }
  }

  Future<void> _shareImage() async {
    final resultData = widget.controller.resultData;
    final imagePath = resultData?.generatedImagePath ?? widget.controller.selectedImagePath;
    if (imagePath == null) return;

    try {
      await Share.shareXFiles([XFile(imagePath)], text: 'Meeting Room AI Redesign');
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Failed to share');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final resultData = widget.controller.resultData;
        final generatedPath = resultData?.generatedImagePath;
        final originalPath = widget.controller.selectedImagePath;

        final currentPath = _showBefore ? originalPath : (generatedPath ?? originalPath);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // COMMAND HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MISSION COMPLETE', style: MeetingRoomText.caption),
                      Text('Meeting Room 101', style: MeetingRoomText.h2),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: MeetingTokens.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: MeetingTokens.success),
                    ),
                    child: Text('READY', style: TextStyle(color: MeetingTokens.success, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // IMAGE & TOGGLE
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(MeetingTokens.radiusLG),
                    child: SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: currentPath != null
                          ? Image.file(File(currentPath), fit: BoxFit.cover)
                          : Container(color: MeetingTokens.surface2),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _showBefore = true),
                      onTapUp: (_) => setState(() => _showBefore = false),
                      onTapCancel: () => setState(() => _showBefore = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: MeetingTokens.bg0.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: MeetingTokens.line),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.touch_app, size: 16, color: MeetingTokens.ink0),
                            const SizedBox(width: 8),
                            Text(
                              'HOLD FOR ORIGINAL',
                              style: MeetingRoomText.small.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // READINESS PANEL
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MeetingTokens.surface,
                  borderRadius: BorderRadius.circular(MeetingTokens.radiusMD),
                  border: Border.all(color: MeetingTokens.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MEETING READINESS NOTES', style: MeetingRoomText.caption),
                    const SizedBox(height: 16),
                    _buildMetric('Lighting', 0.9, 'Daylight optimized'),
                    _buildMetric('Acoustics', 0.7, 'Paneling suggested'),
                    _buildMetric('Capacity', 1.0, 'Matches 8p req'),
                    _buildMetric('Tech', 0.8, 'Dual screen ready'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ACTION BAR
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveToGallery,
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Column(children: [Icon(Icons.save_alt), SizedBox(height: 4), Text('SAVE')]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _shareImage,
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Column(children: [Icon(Icons.share), SizedBox(height: 4), Text('SHARE')]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => widget.controller.goToStep(1), // Back to Style
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Column(children: [Icon(Icons.refresh), SizedBox(height: 4), Text('REGEN')]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              GradientButton(
                label: 'EXIT TO COMMAND',
                onPressed: () {
                  widget.controller.resetWizard();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetric(String label, double value, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: MeetingRoomText.bodySemiBold)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: value,
                  backgroundColor: MeetingTokens.bg0,
                  valueColor: AlwaysStoppedAnimation(MeetingTokens.accent),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 4),
                Text(note, style: MeetingRoomText.small.copyWith(color: MeetingTokens.muted, fontSize: 10)),
              ],
            ),
          ),
          Text('${(value * 100).toInt()}%', style: MeetingRoomText.small),
        ],
      ),
    );
  }
}

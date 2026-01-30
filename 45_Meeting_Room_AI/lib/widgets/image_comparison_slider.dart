// lib/widgets/image_comparison_slider.dart
// Before/After image comparison with interactive slider

import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/meeting_room_theme.dart';

class ImageComparisonSlider extends StatefulWidget {
  const ImageComparisonSlider({
    super.key,
    required this.beforeImagePath,
    required this.afterImagePath,
  });

  final String beforeImagePath;
  final String afterImagePath;

  @override
  State<ImageComparisonSlider> createState() => _ImageComparisonSliderState();
}

class _ImageComparisonSliderState extends State<ImageComparisonSlider>
    with SingleTickerProviderStateMixin {
  double _dividerPosition = 0.5; // Center position (0.0 to 1.0)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the slider handle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dividerPosition = (_dividerPosition + details.delta.dx / MediaQuery.of(context).size.width)
              .clamp(0.0, 1.0);
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final dividerX = width * _dividerPosition;

          return Stack(
            alignment: Alignment.center,
            children: [
              // AFTER image (full width, height adjusts)
              Image.file(
                File(widget.afterImagePath),
                width: width,
                fit: BoxFit.contain,
              ),

              // BEFORE image (clipped by divider position)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: dividerX,
                child: ClipRect(
                  child: Image.file(
                    File(widget.beforeImagePath),
                    width: width,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),

              // Labels
              Positioned(
                left: 16,
                top: 16,
                child: _buildLabel('BEFORE', MeetingAIColors.error),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: _buildLabel('AFTER', MeetingAIColors.success),
              ),

              // Divider line and handle
              Positioned(
                left: dividerX - 2,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  color: MeetingAIColors.canvasWhite,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: MeetingAIColors.leatherTan,
                              shape: BoxShape.circle,
                              boxShadow: MeetingAIShadows.tanGlow(opacity: 0.5),
                              border: Border.all(
                                color: MeetingAIColors.canvasWhite,
                                width: 3,
                              ),
                            ),
                            child: Icon(
                              Icons.compare_arrows,
                              color: MeetingAIColors.canvasWhite,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Instruction text
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MeetingAISpacing.lg,
                      vertical: MeetingAISpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: MeetingAIColors.soleBlack.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: MeetingAIColors.canvasWhite.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swipe_rounded,
                          color: MeetingAIColors.leatherTan,
                          size: 20,
                        ),
                        const SizedBox(width: MeetingAISpacing.sm),
                        Text(
                          'Drag slider to compare',
                          style: MeetingAIText.bodyMedium.copyWith(
                            color: MeetingAIColors.canvasWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MeetingAISpacing.md,
        vertical: MeetingAISpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: MeetingAIText.bodyMedium.copyWith(
          color: MeetingAIColors.canvasWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// lib/widgets/image_comparison_slider.dart
// Before/After image comparison with interactive slider

import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/balcony_terrace_ai_theme.dart';

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
                child: _buildLabel('BEFORE', TerraceAIColors.error),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: _buildLabel('AFTER', TerraceAIColors.success),
              ),

              // Divider line and handle
              Positioned(
                left: dividerX - 2,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  color: TerraceAIColors.canvasWhite,
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
                              color: TerraceAIColors.leatherTan,
                              shape: BoxShape.circle,
                              boxShadow: TerraceAIShadows.tanGlow(opacity: 0.5),
                              border: Border.all(
                                color: TerraceAIColors.canvasWhite,
                                width: 3,
                              ),
                            ),
                            child: Icon(
                              Icons.compare_arrows,
                              color: TerraceAIColors.canvasWhite,
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
                      horizontal: TerraceAISpacing.lg,
                      vertical: TerraceAISpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: TerraceAIColors.soleBlack.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: TerraceAIColors.canvasWhite.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swipe_rounded,
                          color: TerraceAIColors.leatherTan,
                          size: 20,
                        ),
                        const SizedBox(width: TerraceAISpacing.sm),
                        Text(
                          'Drag slider to compare',
                          style: TerraceAIText.bodyMedium.copyWith(
                            color: TerraceAIColors.canvasWhite,
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
        horizontal: TerraceAISpacing.md,
        vertical: TerraceAISpacing.sm,
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
        style: TerraceAIText.bodyMedium.copyWith(
          color: TerraceAIColors.canvasWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

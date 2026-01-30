import 'package:flutter/material.dart';
import 'dart:io';
import '../../../theme/camper_tokens.dart';

class TapOrSwipeCompareToggle extends StatefulWidget {
  final String beforeImage;
  final String afterImage;

  const TapOrSwipeCompareToggle({
    super.key,
    required this.beforeImage,
    required this.afterImage,
  });

  @override
  State<TapOrSwipeCompareToggle> createState() => _TapOrSwipeCompareToggleState();
}

class _TapOrSwipeCompareToggleState extends State<TapOrSwipeCompareToggle> {
  bool _showAfter = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAfter = !_showAfter;
        });
      },
      child: Stack(
        children: [
          // Image Container
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CamperTokens.radiusL),
              color: CamperTokens.bg0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(CamperTokens.radiusL),
              child: AnimatedCrossFade(
                firstChild: Image.file(File(widget.beforeImage), fit: BoxFit.cover, height: 400, width: double.infinity),
                secondChild: Image.file(File(widget.afterImage), fit: BoxFit.cover, height: 400, width: double.infinity),
                crossFadeState: _showAfter ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),

          // Pill Switch (Bottom Center)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PillOption("Before", !_showAfter),
                    _PillOption("After", _showAfter),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _PillOption(this.label, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? CamperTokens.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../theme/camper_theme.dart';

class TapOrSwipeCompareToggle extends StatelessWidget {
  final bool isBefore;
  final VoidCallback onToggle;

  const TapOrSwipeCompareToggle({
    super.key,
    required this.isBefore,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 40,
        width: 140,
        decoration: BoxDecoration(
          color: CamperAIColors.soleBlack.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CamperAIColors.canvasWhite.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isBefore ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                  color: CamperAIColors.leatherTan,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    isBefore ? "Before" : "After",
                    style: CamperAIText.caption.copyWith(
                      color: CamperAIColors.soleBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

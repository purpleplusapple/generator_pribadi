import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TapOrSwipeCompareToggle extends StatelessWidget {
  final bool isAfter;
  final VoidCallback onToggle;

  const TapOrSwipeCompareToggle({
    super.key,
    required this.isAfter,
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
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isAfter ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                  color: StudyAIColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Before',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: !isAfter ? StudyAIColors.bg0 : Colors.white70,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'After',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAfter ? StudyAIColors.bg0 : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

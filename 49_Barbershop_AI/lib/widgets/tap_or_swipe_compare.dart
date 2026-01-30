import 'package:flutter/material.dart';
import '../../theme/barber_theme.dart';

class TapOrSwipeCompareToggle extends StatefulWidget {
  final ImageProvider beforeImage;
  final ImageProvider afterImage;

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
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0 && !_showAfter) {
           setState(() => _showAfter = true);
        } else if (details.primaryDelta! < 0 && _showAfter) {
           setState(() => _showAfter = false);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Images
          AnimatedCrossFade(
            firstChild: Image(image: widget.beforeImage, fit: BoxFit.cover),
            secondChild: Image(image: widget.afterImage, fit: BoxFit.cover),
            crossFadeState: _showAfter ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),

          // Pill Indicator
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PillButton(label: "Before", isActive: !_showAfter, onTap: () => setState(() => _showAfter = false)),
                    _PillButton(label: "After", isActive: _showAfter, onTap: () => setState(() => _showAfter = true)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _PillButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? BarberTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? BarberTheme.bg0 : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

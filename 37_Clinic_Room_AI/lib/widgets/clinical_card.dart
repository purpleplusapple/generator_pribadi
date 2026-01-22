import 'package:flutter/material.dart';
import '../theme/clinic_theme.dart';

class ClinicalCard extends StatelessWidget {
  const ClinicalCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? ClinicColors.bg1,
        shape: RoundedRectangleBorder(
          borderRadius: ClinicRadius.mediumRadius,
          side: BorderSide(
            color: borderColor ?? ClinicColors.line,
            width: 1,
          ),
        ),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: ClinicRadius.mediumRadius,
          child: Container(
            padding: padding ?? const EdgeInsets.all(ClinicSpacing.base),
            decoration: BoxDecoration(
              borderRadius: ClinicRadius.mediumRadius,
              boxShadow: ClinicShadows.card,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

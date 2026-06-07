import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/shadows.dart';

class SkeuCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final List<BoxShadow>? customShadows;
  final Color? color;

  const SkeuCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.customShadows,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: customShadows ?? AppShadows.skeuoShadow,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (color ?? AppColors.surface).withValues(alpha: 0.8),
            (color ?? AppColors.surface),
          ],
        ),
      ),
      child: child,
    );
  }
}

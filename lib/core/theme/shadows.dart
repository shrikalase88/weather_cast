import 'package:flutter/material.dart';
import 'colors.dart';

class AppShadows {
  static List<BoxShadow> skeuoShadow = [
    const BoxShadow(
      color: AppColors.shadowDark,
      offset: Offset(4, 4),
      blurRadius: 10,
      spreadRadius: 1,
    ),
    const BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(-4, -4),
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];

  static List<BoxShadow> skeuoInnerShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.05),
      offset: const Offset(-2, -2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  static BoxShadow skeuOuterGlow = BoxShadow(
    color: AppColors.accent.withValues(alpha: 0.2),
    blurRadius: 8,
    spreadRadius: 1,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/colors.dart';
import '../core/theme/shadows.dart';

class SkeuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final Color? color;

  const SkeuButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = 12,
    this.color,
  });

  @override
  State<SkeuButton> createState() => _SkeuButtonState();
}

class _SkeuButtonState extends State<SkeuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: 100.ms,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.surface,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed ? AppShadows.skeuoInnerShadow : AppShadows.skeuoShadow,
        ),
        child: widget.child,
      ).animate(target: _isPressed ? 1 : 0).scale(
            begin: const Offset(1, 1),
            end: const Offset(0.96, 0.96),
            duration: 100.ms,
          ),
    );
  }
}

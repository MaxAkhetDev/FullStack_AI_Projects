import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kSurfaceContainerHigh.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kOutlineVariant.withOpacity(0.15)),
          ),
          child: child,
        ),
      ),
    );
  }
}

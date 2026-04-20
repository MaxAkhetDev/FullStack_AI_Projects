import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CboButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool secondary;

  const CboButton({
    super.key,
    required this.label,
    this.onPressed,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (secondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: kOutlineVariant.withOpacity(0.15)),
          backgroundColor: kSurfaceContainerHigh.withOpacity(0.2),
          foregroundColor: kOnSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: Text(label),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kPrimaryContainer, kPrimary]),
        borderRadius: BorderRadius.circular(2),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: kOnSurface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

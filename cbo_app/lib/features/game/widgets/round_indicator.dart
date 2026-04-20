import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class RoundIndicator extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final int rollsRemaining;

  const RoundIndicator({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    required this.rollsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Manche $currentRound/$totalRounds',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: kOnSurfaceVariant),
        ),
        Row(
          children: List.generate(
            rollsRemaining,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Icon(Icons.circle, color: kPrimary, size: 10),
            ),
          ),
        ),
      ],
    );
  }
}

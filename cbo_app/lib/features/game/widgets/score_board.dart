import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/glass_card.dart';

class ScoreBoard extends StatelessWidget {
  final List<Player> players;
  final String? currentPlayerId;

  const ScoreBoard({
    super.key,
    required this.players,
    this.currentPlayerId,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...players]..sort((a, b) => b.score.compareTo(a.score));
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: sorted
            .map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: p.id == currentPlayerId
                          ? const Icon(
                              Icons.play_arrow,
                              color: kTertiary,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        p.name,
                        style: const TextStyle(color: kOnSurface),
                      ),
                    ),
                    Text(
                      '${p.score}',
                      style: const TextStyle(
                        color: kTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

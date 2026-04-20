import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../shared/models/player.dart';
import '../../shared/widgets/cbo_button.dart';
import '../../shared/widgets/glass_card.dart';

class EndGameScreen extends StatelessWidget {
  final List<dynamic> players;

  const EndGameScreen({super.key, required this.players});

  List<Player> _parsedPlayers() {
    return players.map((p) {
      if (p is Player) return p;
      return Player.fromJson(p as Map<String, dynamic>);
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _parsedPlayers();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fin de partie',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  children: sorted.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final p = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text(
                              '$rank.',
                              style: TextStyle(
                                color: rank == 1
                                    ? kTertiary
                                    : kOnSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p.name,
                              style: const TextStyle(color: kOnSurface),
                            ),
                          ),
                          Text(
                            '${p.score} pts',
                            style: const TextStyle(
                              color: kTertiary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _LevelBadge(level: p.level),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CboButton(
                  label: 'Nouvelle partie',
                  onPressed: () => context.go('/'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CboButton(
                  label: 'Rejouer',
                  secondary: true,
                  onPressed: () => context.go('/'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;

  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: kTertiary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: kTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Manrope',
        ),
      ),
    );
  }
}

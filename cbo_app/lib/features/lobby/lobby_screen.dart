import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants.dart';
import '../../shared/widgets/cbo_button.dart';
import '../../shared/widgets/glass_card.dart';
import 'lobby_provider.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  final String sessionCode;

  const LobbyScreen({super.key, required this.sessionCode});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  @override
  void initState() {
    super.initState();
    // If arriving via deep link (no existing session), auto-join
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(lobbyProvider).value;
      if (current == null) {
        ref.read(lobbyProvider.notifier).joinGame(
              widget.sessionCode,
              'Joueur${DateTime.now().millisecondsSinceEpoch % 1000}',
            );
      }
    });
  }

  void _shareInvite() {
    Share.share(
      'Rejoins ma partie CBO !\nhttps://cbo.app/join/${widget.sessionCode}',
      subject: 'Invitation CBO – ${widget.sessionCode}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(lobbyProvider);
    final notifier = ref.read(lobbyProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: sessionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Erreur: $e', style: Theme.of(context).textTheme.bodyMedium),
          ),
          data: (session) {
            if (session == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final players = session.players.values.toList();

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lobby',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.sessionCode,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      color: kTertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Joueurs',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const Spacer(),
                            Text(
                              '${players.length}/6',
                              style: const TextStyle(
                                color: kTertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (players.isEmpty)
                          const Text(
                            'En attente de joueurs...',
                            style: TextStyle(color: kOnSurfaceVariant),
                          )
                        else
                          ...players.map(
                            (p) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    color: kOnSurfaceVariant,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    p.name,
                                    style:
                                        const TextStyle(color: kOnSurface),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CboButton(
                      label: 'Inviter des joueurs',
                      secondary: true,
                      onPressed: _shareInvite,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: CboButton(
                      label: 'Lancer la partie',
                      onPressed: () => context.go(
                        '/game/${widget.sessionCode}',
                        extra: {'playerId': notifier.playerId},
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../shared/models/game_session.dart';
import '../lobby/lobby_provider.dart';
import 'game_provider.dart';
import 'widgets/cbo_grid.dart';
import 'widgets/dice_widget.dart';
import 'widgets/score_board.dart';
import 'widgets/round_indicator.dart';

class GameScreen extends ConsumerStatefulWidget {
  final String sessionCode;
  final String playerId;

  const GameScreen({
    super.key,
    required this.sessionCode,
    required this.playerId,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _rolling = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  void _initialize() {
    if (_initialized) return;
    _initialized = true;

    final lobbySession = ref.read(lobbyProvider).value;
    final grid = lobbySession?.grid ??
        List.generate(4, (r) => List.generate(3, (c) => r * 3 + c + 1));

    ref.read(gameProvider.notifier).connect(
          widget.sessionCode,
          widget.playerId,
          grid,
        );
    ref.read(gameProvider.notifier).startGame(widget.playerId);
  }

  Future<void> _roll() async {
    if (_rolling) return;
    setState(() => _rolling = true);
    ref.read(gameProvider.notifier).roll(widget.playerId);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _rolling = false);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gameProvider);

    // Listen for game over — navigate exactly once
    ref.listen<GameSession?>(gameProvider, (previous, next) {
      if (next?.status == GameStatus.finished &&
          previous?.status != GameStatus.finished) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go(
              '/results/${widget.sessionCode}',
              extra: {'players': next!.players.values.toList()},
            );
          }
        });
      }
    });

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isMyTurn = session.currentPlayerId == widget.playerId;
    // currentRolls updates synchronously with state changes, safe to read after watch triggers rebuild
    final notifier = ref.read(gameProvider.notifier);
    final rolls = notifier.currentRolls;
    final lastRoll = rolls.isNotEmpty ? rolls.last : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              RoundIndicator(
                currentRound: session.currentRound,
                totalRounds: 13,
                rollsRemaining: session.rollsRemaining,
              ),
              const SizedBox(height: 20),
              CboGrid(
                grid: session.grid,
                highlightedNumbers: rolls,
              ),
              const SizedBox(height: 24),
              ScoreBoard(
                players: session.players.values.toList(),
                currentPlayerId: session.currentPlayerId,
              ),
              const Spacer(),
              DiceWidget(
                value: lastRoll,
                rolling: _rolling,
                onTap: isMyTurn && session.rollsRemaining > 0 && !_rolling
                    ? _roll
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                isMyTurn
                    ? session.rollsRemaining > 0
                        ? 'Tap le dé pour lancer'
                        : 'En attente...'
                    : 'En attente de ${_currentPlayerName(session)}...',
                style: TextStyle(
                  color: isMyTurn && session.rollsRemaining > 0
                      ? kTertiary
                      : kOnSurfaceVariant,
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _currentPlayerName(GameSession session) {
    final pid = session.currentPlayerId;
    if (pid == null) return '...';
    return session.players[pid]?.name ?? '...';
  }
}

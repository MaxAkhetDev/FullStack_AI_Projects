import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/game_session.dart';
import '../../shared/models/player.dart';
import '../../shared/models/ws_message.dart';
import 'game_service.dart';

class GameNotifier extends StateNotifier<GameSession?> {
  final GameService _service;
  List<int> _currentRolls = [];

  List<int> get currentRolls => List<int>.unmodifiable(_currentRolls);

  GameNotifier(this._service) : super(null);

  void connect(String code, String playerId, List<List<int>> grid) {
    _service.connect(code, playerId);
    state = GameSession.initial(code, 'Débutant', grid);
    _service.messages.listen(_handleMessage);
  }

  void startGame(String playerId) => _service.startGame(playerId);

  void roll(String playerId) => _service.roll(playerId);

  void _handleMessage(WsMessage msg) {
    final payload = msg.payload is Map
        ? Map<String, dynamic>.from(msg.payload as Map)
        : <String, dynamic>{};

    switch (msg.type) {
      case 'player_joined':
        final players = <String, Player>{};
        for (final p in (payload['players'] as List? ?? [])) {
          final player = Player.fromJson(p as Map<String, dynamic>);
          players[player.id] = player;
        }
        state = state?.copyWith(
          players: Map<String, Player>.unmodifiable(players),
        );

      case 'game_started':
        final currentPlayer = payload['current_player'] as String?;
        final round = payload['current_round'] as int? ?? 1;
        final rollsLeft = payload['rolls_remaining'] as int? ?? 3;
        _currentRolls = [];
        state = state?.copyWith(
          status: GameStatus.playing,
          currentRound: round,
          currentPlayerId: currentPlayer,
          rollsRemaining: rollsLeft,
        );

      case 'roll_result':
        final pid = payload['player_id'] as String;
        final rolls = List<int>.from(payload['rolls'] as List? ?? []);
        _currentRolls = rolls;
        final totalScore = payload['total_score'] as int? ?? 0;
        final updatedPlayers = Map<String, Player>.from(state?.players ?? {});
        if (updatedPlayers.containsKey(pid)) {
          updatedPlayers[pid] = updatedPlayers[pid]!.copyWith(score: totalScore);
        }
        state = state?.copyWith(
          players: Map<String, Player>.unmodifiable(updatedPlayers),
          rollsRemaining: payload['rolls_left'] as int? ?? 0,
        );

      case 'next_turn':
        _currentRolls = [];
        state = state?.copyWith(
          currentRound: payload['current_round'] as int? ?? state!.currentRound,
          currentPlayerId: payload['current_player'] as String?,
          rollsRemaining: payload['rolls_remaining'] as int? ?? 3,
        );

      case 'game_over':
        final players = <String, Player>{};
        for (final p in (payload['players'] as List? ?? [])) {
          final player = Player.fromJson(p as Map<String, dynamic>);
          players[player.id] = player;
        }
        state = state?.copyWith(
          status: GameStatus.finished,
          players: Map<String, Player>.unmodifiable(players),
        );

      case 'player_disconnected':
        // No state change needed — server handles reconnection
        break;
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

final gameServiceProvider = Provider<GameService>((ref) => GameService());

final gameProvider = StateNotifierProvider<GameNotifier, GameSession?>((ref) {
  return GameNotifier(ref.read(gameServiceProvider));
});

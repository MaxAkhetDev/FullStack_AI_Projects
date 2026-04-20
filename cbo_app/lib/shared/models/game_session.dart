import 'player.dart';

enum GameStatus { lobby, playing, finished }

class GameSession {
  final String code;
  final String mode;
  final List<List<int>> grid;
  final GameStatus status;
  final Map<String, Player> players;
  final int currentRound;
  final String? currentPlayerId;
  final int rollsRemaining;

  const GameSession({
    required this.code,
    required this.mode,
    required this.grid,
    required this.status,
    required this.players,
    required this.currentRound,
    this.currentPlayerId,
    required this.rollsRemaining,
  });

  factory GameSession.initial(String code, String mode, List<List<int>> grid) => GameSession(
        code: code,
        mode: mode,
        grid: List<List<int>>.unmodifiable(
          grid.map((row) => List<int>.unmodifiable(row)).toList(),
        ),
        status: GameStatus.lobby,
        players: const {},
        currentRound: 0,
        rollsRemaining: mode == 'Débutant' ? 4 : 3,
      );

  GameSession copyWith({
    GameStatus? status,
    Map<String, Player>? players,
    int? currentRound,
    String? currentPlayerId,
    int? rollsRemaining,
  }) =>
      GameSession(
        code: code,
        mode: mode,
        grid: grid,
        status: status ?? this.status,
        players: players != null ? Map<String, Player>.unmodifiable(players) : this.players,
        currentRound: currentRound ?? this.currentRound,
        currentPlayerId: currentPlayerId ?? this.currentPlayerId,
        rollsRemaining: rollsRemaining ?? this.rollsRemaining,
      );
}

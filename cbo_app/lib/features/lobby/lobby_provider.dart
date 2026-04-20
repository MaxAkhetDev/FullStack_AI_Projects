import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../shared/models/game_session.dart';

class LobbyNotifier extends StateNotifier<AsyncValue<GameSession?>> {
  LobbyNotifier() : super(const AsyncValue.data(null));

  String _playerId = '';
  String get playerId => _playerId;

  Future<GameSession> createGame(String playerName) async {
    state = const AsyncValue.loading();
    try {
      final resp = await http.post(
        Uri.parse('$kApiBaseUrl/games'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'player_name': playerName, 'mode': 'Débutant'}),
      );
      if (resp.statusCode != 201) {
        throw Exception('Failed to create game: ${resp.statusCode}');
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      _playerId = data['player_id'] as String;
      final grid = (data['grid'] as List)
          .map((row) => List<int>.unmodifiable(row as List<dynamic>))
          .toList();
      final session = GameSession.initial(
        data['session_code'] as String,
        'Débutant',
        List<List<int>>.unmodifiable(grid),
      );
      state = AsyncValue.data(session);
      return session;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<GameSession> joinGame(String code, String playerName) async {
    state = const AsyncValue.loading();
    try {
      final resp = await http.post(
        Uri.parse('$kApiBaseUrl/games/$code/join'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'player_name': playerName}),
      );
      if (resp.statusCode != 200) {
        throw Exception('Failed to join game: ${resp.statusCode}');
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      _playerId = data['player_id'] as String;
      final grid = (data['grid'] as List)
          .map((row) => List<int>.unmodifiable(row as List<dynamic>))
          .toList();
      final session = GameSession.initial(
        code,
        'Débutant',
        List<List<int>>.unmodifiable(grid),
      );
      state = AsyncValue.data(session);
      return session;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final lobbyProvider =
    StateNotifierProvider<LobbyNotifier, AsyncValue<GameSession?>>((ref) {
  return LobbyNotifier();
});

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cbo_app/features/game/game_provider.dart';
import 'package:cbo_app/features/game/game_service.dart';
import 'package:cbo_app/shared/models/game_session.dart';
import 'package:cbo_app/shared/models/ws_message.dart';

// Fake GameService that exposes a stream controller for testing
class FakeGameService extends GameService {
  final _fakeController = StreamController<WsMessage>.broadcast();

  @override
  Stream<WsMessage> get messages => _fakeController.stream;

  @override
  void connect(String sessionCode, String playerId) {
    // Don't actually connect — just register the stream listener
  }

  @override
  void send(WsMessage msg) {}

  @override
  void startGame(String playerId) {}

  @override
  void roll(String playerId) {}

  void inject(WsMessage msg) => _fakeController.add(msg);

  @override
  void dispose() {
    _fakeController.close();
  }
}

void main() {
  final testGrid = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [10, 11, 12],
  ];

  group('GameNotifier', () {
    late FakeGameService fakeService;
    late GameNotifier notifier;

    setUp(() {
      fakeService = FakeGameService();
      notifier = GameNotifier(fakeService);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('connect initializes session in lobby state', () {
      notifier.connect('CBO-TEST', 'p1', testGrid);
      expect(notifier.state?.code, 'CBO-TEST');
      expect(notifier.state?.status, GameStatus.lobby);
    });

    test('game_started message transitions to playing state', () async {
      notifier.connect('CBO-TEST', 'p1', testGrid);
      fakeService.inject(WsMessage(
        type: 'game_started',
        payload: <String, dynamic>{
          'current_round': 1,
          'current_player': 'p1',
          'rolls_remaining': 3,
        },
      ));
      await Future.microtask(() {});
      expect(notifier.state?.status, GameStatus.playing);
      expect(notifier.state?.currentRound, 1);
      expect(notifier.state?.currentPlayerId, 'p1');
    });

    test('roll_result updates player score and rolls', () async {
      notifier.connect('CBO-TEST', 'p1', testGrid);
      // First set up a player via player_joined
      fakeService.inject(WsMessage(
        type: 'player_joined',
        payload: <String, dynamic>{
          'players': [
            {'id': 'p1', 'name': 'Alice', 'score': 0, 'level': 'Débutant', 'rounds': <dynamic>[]}
          ],
          'status': 'lobby',
        },
      ));
      await Future.microtask(() {});
      fakeService.inject(WsMessage(
        type: 'roll_result',
        payload: <String, dynamic>{
          'player_id': 'p1',
          'rolls': [1, 2, 3],
          'rolls_left': 1,
          'total_score': 3,
        },
      ));
      await Future.microtask(() {});
      expect(notifier.state?.players['p1']?.score, 3);
      expect(notifier.currentRolls, [1, 2, 3]);
    });

    test('next_turn clears current rolls', () async {
      notifier.connect('CBO-TEST', 'p1', testGrid);
      fakeService.inject(WsMessage(
        type: 'next_turn',
        payload: <String, dynamic>{
          'current_round': 2,
          'current_player': 'p2',
          'rolls_remaining': 3,
        },
      ));
      await Future.microtask(() {});
      expect(notifier.currentRolls, isEmpty);
      expect(notifier.state?.currentRound, 2);
    });

    test('game_over transitions to finished state', () async {
      notifier.connect('CBO-TEST', 'p1', testGrid);
      fakeService.inject(WsMessage(
        type: 'game_over',
        payload: <String, dynamic>{
          'players': [
            {'id': 'p1', 'name': 'Alice', 'score': 27, 'level': 'Avancé', 'rounds': <dynamic>[]}
          ],
        },
      ));
      await Future.microtask(() {});
      expect(notifier.state?.status, GameStatus.finished);
    });
  });
}

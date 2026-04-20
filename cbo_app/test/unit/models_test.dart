import 'package:flutter_test/flutter_test.dart';
import 'package:cbo_app/shared/models/player.dart';
import 'package:cbo_app/shared/models/ws_message.dart';
import 'package:cbo_app/shared/models/game_session.dart';

void main() {
  group('Player', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'p1',
        'name': 'Alice',
        'score': 9,
        'level': 'Débutant',
        'rounds': <dynamic>[],
      };
      final player = Player.fromJson(json);
      expect(player.name, 'Alice');
      expect(player.score, 9);
      expect(player.level, 'Débutant');
    });

    test('copyWith preserves unchanged fields', () {
      const player = Player(id: 'p1', name: 'Alice', score: 0, level: 'Débutant', rounds: []);
      final updated = player.copyWith(score: 9);
      expect(updated.id, 'p1');
      expect(updated.score, 9);
      expect(updated.name, 'Alice');
    });
  });

  group('WsMessage', () {
    test('fromJson parses type and payload', () {
      final json = {'type': 'roll_result', 'payload': <String, dynamic>{'roll': 7}};
      final msg = WsMessage.fromJson(json);
      expect(msg.type, 'roll_result');
      expect((msg.payload as Map)['roll'], 7);
    });

    test('toJson round-trips correctly', () {
      const msg = WsMessage(type: 'roll', payload: <String, dynamic>{'player_id': 'p1'});
      final json = msg.toJson();
      expect(json['type'], 'roll');
    });
  });

  group('GameSession', () {
    test('initial creates lobby state', () {
      final session = GameSession.initial('CBO-TEST', 'Débutant', [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]);
      expect(session.status, GameStatus.lobby);
      expect(session.rollsRemaining, 4);
      expect(session.players, isEmpty);
    });

    test('Avancé mode gets 3 rolls', () {
      final session = GameSession.initial('CBO-TEST', 'Avancé', [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]);
      expect(session.rollsRemaining, 3);
    });

    test('copyWith updates status', () {
      final session = GameSession.initial('CBO-TEST', 'Débutant', [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]);
      final updated = session.copyWith(status: GameStatus.playing);
      expect(updated.status, GameStatus.playing);
      expect(updated.code, 'CBO-TEST');
    });
  });
}

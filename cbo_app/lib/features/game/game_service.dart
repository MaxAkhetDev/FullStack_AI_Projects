import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/constants.dart';
import '../../shared/models/ws_message.dart';

class GameService {
  WebSocketChannel? _channel;
  final _controller = StreamController<WsMessage>.broadcast();

  Stream<WsMessage> get messages => _controller.stream;

  void connect(String sessionCode, String playerId) {
    _channel = WebSocketChannel.connect(
      Uri.parse('$kWsBaseUrl/ws/$sessionCode'),
    );
    _channel!.stream.listen(
      (data) {
        final json = jsonDecode(data as String) as Map<String, dynamic>;
        _controller.add(WsMessage.fromJson(json));
      },
      onError: (Object e) {
        _controller.addError(e);
      },
      onDone: () {
        if (!_controller.isClosed) _controller.close();
      },
    );
    send(WsMessage(type: 'connect', payload: <String, dynamic>{'player_id': playerId}));
  }

  void send(WsMessage msg) {
    _channel?.sink.add(jsonEncode(msg.toJson()));
  }

  void startGame(String playerId) =>
      send(WsMessage(type: 'start', payload: <String, dynamic>{'player_id': playerId}));

  void roll(String playerId) =>
      send(WsMessage(type: 'roll', payload: <String, dynamic>{'player_id': playerId}));

  void dispose() {
    _channel?.sink.close();
    if (!_controller.isClosed) _controller.close();
  }
}

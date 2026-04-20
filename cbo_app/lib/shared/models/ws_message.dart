class WsMessage {
  final String type;
  // payload is dynamic: different WS message types carry different payload shapes
  final dynamic payload;

  const WsMessage({required this.type, required this.payload});

  factory WsMessage.fromJson(Map<String, dynamic> json) =>
      WsMessage(type: json['type'] as String, payload: json['payload']);

  Map<String, dynamic> toJson() => {'type': type, 'payload': payload};
}

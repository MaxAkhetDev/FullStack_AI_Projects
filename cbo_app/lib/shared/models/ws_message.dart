class WsMessage {
  final String type;
  final dynamic payload;

  const WsMessage({required this.type, required this.payload});

  factory WsMessage.fromJson(Map<String, dynamic> json) =>
      WsMessage(type: json['type'] as String, payload: json['payload']);

  Map<String, dynamic> toJson() => {'type': type, 'payload': payload};
}

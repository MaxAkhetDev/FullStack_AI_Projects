import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final String sessionCode;
  final String playerId;

  const GameScreen({
    super.key,
    required this.sessionCode,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Game: $sessionCode')),
  );
}

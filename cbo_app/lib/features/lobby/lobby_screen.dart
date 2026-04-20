import 'package:flutter/material.dart';

class LobbyScreen extends StatelessWidget {
  final String sessionCode;

  const LobbyScreen({super.key, required this.sessionCode});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text('Lobby: $sessionCode')),
  );
}

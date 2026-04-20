import 'package:flutter/material.dart';

class EndGameScreen extends StatelessWidget {
  final List<dynamic> players;

  const EndGameScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Results')),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cbo_app/features/home/home_screen.dart';
import 'package:cbo_app/core/theme.dart';

void main() {
  testWidgets('HomeScreen shows title, subtitle and Start & Play button', (tester) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        theme: buildCelestialTheme(),
        home: const HomeScreen(),
      ),
    ));
    expect(find.text('CBO'), findsOneWidget);
    expect(find.text('Le Jeu de Synchronicité'), findsOneWidget);
    expect(find.text('Start & Play'), findsOneWidget);
    expect(find.text('Règles du jeu'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
  });
}

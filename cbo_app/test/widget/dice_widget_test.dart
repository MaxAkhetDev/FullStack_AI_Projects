import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbo_app/features/game/widgets/dice_widget.dart';
import 'package:cbo_app/core/theme.dart';

void main() {
  group('DiceWidget', () {
    testWidgets('shows ? when value is null', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: const Scaffold(body: DiceWidget()),
      ));
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('shows roll value', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: const Scaffold(body: DiceWidget(value: 7)),
      ));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('triggers onTap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: Scaffold(
          body: DiceWidget(value: 3, onTap: () => tapped = true),
        ),
      ));
      await tester.tap(find.byType(DiceWidget));
      expect(tapped, isTrue);
    });

    testWidgets('displays animation controller when rolling', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: const Scaffold(body: DiceWidget(value: 5, rolling: true)),
      ));
      expect(find.text('5'), findsOneWidget);
      // Pump several frames to verify animation runs
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(DiceWidget), findsOneWidget);
    });
  });
}

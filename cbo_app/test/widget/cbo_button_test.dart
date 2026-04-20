import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbo_app/shared/widgets/cbo_button.dart';
import 'package:cbo_app/core/theme.dart';

void main() {
  group('CboButton', () {
    testWidgets('primary renders label and triggers onPressed', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: Scaffold(
          body: CboButton(label: 'Start', onPressed: () => pressed = true),
        ),
      ));
      expect(find.text('Start'), findsOneWidget);
      await tester.tap(find.text('Start'));
      expect(pressed, isTrue);
    });

    testWidgets('secondary variant renders without gradient container', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: Scaffold(
          body: CboButton(label: 'Rules', secondary: true, onPressed: () {}),
        ),
      ));
      expect(find.text('Rules'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildCelestialTheme(),
        home: const Scaffold(
          body: CboButton(label: 'Disabled'),
        ),
      ));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}

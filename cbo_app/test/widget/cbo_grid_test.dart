import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbo_app/features/game/widgets/cbo_grid.dart';
import 'package:cbo_app/core/theme.dart';

void main() {
  final testGrid = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [10, 11, 12],
  ];

  testWidgets('CboGrid displays all 12 numbers', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildCelestialTheme(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: CboGrid(grid: testGrid, highlightedNumbers: const []),
        ),
      ),
    ));
    for (int i = 1; i <= 12; i++) {
      expect(find.text('$i'), findsOneWidget);
    }
    await tester.pumpAndSettle();
  });

  testWidgets('CboGrid creates keys for all cells', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildCelestialTheme(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: CboGrid(grid: testGrid, highlightedNumbers: const [1, 5, 9]),
        ),
      ),
    ));
    expect(find.byKey(const ValueKey('cell_1')), findsOneWidget);
    expect(find.byKey(const ValueKey('cell_5')), findsOneWidget);
    expect(find.byKey(const ValueKey('cell_9')), findsOneWidget);
    expect(find.byKey(const ValueKey('cell_12')), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('CboGrid renders 4 rows', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildCelestialTheme(),
      home: Scaffold(
        body: SizedBox(
          width: 360,
          height: 600,
          child: CboGrid(grid: testGrid, highlightedNumbers: const []),
        ),
      ),
    ));
    // 4 rows of 3 cells = 12 Text widgets
    expect(find.byType(Text), findsNWidgets(12));
    await tester.pumpAndSettle();
  });
}

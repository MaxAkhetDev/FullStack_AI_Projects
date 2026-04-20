import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbo_app/core/theme.dart';

void main() {
  testWidgets('CBO placeholder renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildCelestialTheme(),
          home: const Scaffold(
            body: Center(child: Text('CBO')),
          ),
        ),
      ),
    );
    expect(find.text('CBO'), findsOneWidget);
  });
}

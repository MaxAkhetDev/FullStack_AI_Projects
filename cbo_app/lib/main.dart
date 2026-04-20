import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';

void main() {
  runApp(const ProviderScope(child: _CboPlaceholder()));
}

class _CboPlaceholder extends StatelessWidget {
  const _CboPlaceholder();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBO',
      theme: buildCelestialTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('CBO', style: Theme.of(context).textTheme.displayLarge),
        ),
      ),
    );
  }
}

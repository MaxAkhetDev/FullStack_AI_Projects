import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData buildCelestialTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kBackground,
    colorScheme: const ColorScheme.dark(
      surface: kBackground,
      primary: kPrimary,
      primaryContainer: kPrimaryContainer,
      tertiary: kTertiary,
      onSurface: kOnSurface,
      onPrimary: kSurfaceContainerLowest,
      outline: kOutlineVariant,
    ),
    fontFamily: 'Manrope',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'NotoSerif', color: kOnSurface, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontFamily: 'NotoSerif', color: kOnSurface, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontFamily: 'Manrope', color: kOnSurface, fontSize: 16),
      bodyMedium: TextStyle(fontFamily: 'Manrope', color: kOnSurfaceVariant, fontSize: 14),
      labelMedium: TextStyle(fontFamily: 'Manrope', color: kOnSurface, letterSpacing: 0.7),
    ),
    useMaterial3: true,
  );
}

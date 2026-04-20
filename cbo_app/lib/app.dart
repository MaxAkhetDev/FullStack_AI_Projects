import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/lobby/lobby_screen.dart';
import 'features/game/game_screen.dart';
import 'features/results/end_game_screen.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/rules/rules_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/sign-in', builder: (_, __) => const SignInScreen()),
    GoRoute(
      path: '/lobby/:code',
      builder: (_, state) => LobbyScreen(
        sessionCode: state.pathParameters['code']!,
      ),
    ),
    GoRoute(
      path: '/join/:code',
      redirect: (_, state) => '/lobby/${state.pathParameters['code']}',
    ),
    GoRoute(
      path: '/game/:code',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return GameScreen(
          sessionCode: state.pathParameters['code']!,
          playerId: extra['playerId'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/results/:code',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return EndGameScreen(
          players: extra['players'] as List? ?? const [],
        );
      },
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/rules', builder: (_, __) => const RulesScreen()),
  ],
);

class CboApp extends StatelessWidget {
  const CboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CBO',
      theme: buildCelestialTheme(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

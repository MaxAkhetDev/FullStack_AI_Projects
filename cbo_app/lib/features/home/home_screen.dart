import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../shared/widgets/cbo_button.dart';
import '../lobby/lobby_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(lobbyProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text(
                'CBO',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Le Jeu de Synchronicité',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: kTertiary,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Un jeu inspiré des enseignements de Bashar. '
                'Entraînez votre synchronicité naturelle, une manche à la fois.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: kOnSurfaceVariant),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CboButton(
                        label: 'Start & Play',
                        onPressed: () => _createAndNavigate(context, ref),
                      ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CboButton(
                  label: 'Règles du jeu',
                  secondary: true,
                  onPressed: () => context.push('/rules'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.push('/sign-in'),
                  child: const Text(
                    'Connexion',
                    style: TextStyle(color: kOnSurfaceVariant),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAndNavigate(BuildContext context, WidgetRef ref) async {
    try {
      final notifier = ref.read(lobbyProvider.notifier);
      final session = await notifier.createGame(
        'Joueur${DateTime.now().millisecondsSinceEpoch % 1000}',
      );
      if (context.mounted) {
        context.push('/lobby/${session.code}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }
}

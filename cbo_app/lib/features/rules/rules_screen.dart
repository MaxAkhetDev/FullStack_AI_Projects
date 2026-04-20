import 'package:flutter/material.dart';
import '../../core/constants.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackground,
        title: const Text('Règles du jeu'),
        foregroundColor: kOnSurface,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleSection(
              title: 'Matériel',
              body: '• Un dé à 12 faces\n• Une grille 4×3 avec les numéros 1 à 12 disposés aléatoirement',
            ),
            SizedBox(height: 20),
            _RuleSection(
              title: 'Déroulement',
              body: '13 manches. Chaque joueur lance le dé à tour de rôle.\n'
                  '• Mode Débutant : 4 lancers par manche\n'
                  '• Mode Avancé : 3 lancers par manche\n\n'
                  'Après vos lancers, les numéros sont vérifiés pour détecter un alignement sur la grille.',
            ),
            SizedBox(height: 20),
            _RuleSection(
              title: 'Alignements',
              body: 'Un alignement est 3 numéros sur la même ligne :\n'
                  '• 4 lignes horizontales\n'
                  '• 3 colonnes verticales\n'
                  '• 2 diagonales',
            ),
            SizedBox(height: 20),
            _RuleSection(
              title: 'Scoring',
              body: '• Aucun alignement → 0 point\n'
                  '• 3 numéros alignés (n\'importe quel ordre) → 3 points\n'
                  '• 3 numéros dans l\'ordre exact de la grille → 9 points',
            ),
            SizedBox(height: 20),
            _RuleSection(
              title: 'Niveaux',
              body: '• Débutant : mode par défaut (4 lancers)\n'
                  '• Avancé : 3 lancers, choisi volontairement\n'
                  '• Maître : obtenu automatiquement si vous répétez la même séquence ordonnée 2 fois dans une partie\n'
                  '• Grand Maître : même séquence ordonnée sur les 13 manches consécutives',
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  final String title;
  final String body;

  const _RuleSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NotoSerif',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kOnSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(body, style: const TextStyle(color: kOnSurfaceVariant, height: 1.5)),
      ],
    );
  }
}

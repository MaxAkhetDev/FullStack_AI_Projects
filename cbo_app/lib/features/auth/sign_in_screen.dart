import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../shared/widgets/cbo_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackground,
        title: const Text('Connexion'),
        foregroundColor: kOnSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: const TextStyle(color: kOnSurface),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: kOnSurfaceVariant),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kOutlineVariant.withOpacity(0.4)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              style: const TextStyle(color: kOnSurface),
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: const TextStyle(color: kOnSurfaceVariant),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kOutlineVariant.withOpacity(0.4)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CboButton(
                label: 'Se connecter',
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Créer un compte',
                style: TextStyle(color: kOnSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

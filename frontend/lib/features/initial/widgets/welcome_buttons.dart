import 'package:flutter/material.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
          ),
          child: const Text(
            'Entrar',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cadastro_usuario');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
          ),
          child: const Text(
            'Cadastrar',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

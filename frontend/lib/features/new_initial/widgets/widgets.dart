import 'package:flutter/material.dart';
import '../components/components.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo (aumentada)
                    Image.asset(
                      'assets/images/new_initial/image 5.png',
                      height: size.height * 0.18,
                    ),
                    const SizedBox(height: 32),
                    // Título
                    Text(
                      'Bem-vindo(A)!',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Subtítulo
                    Text(
                      'Construa hábitos reais. Um dia de cada vez.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Botão Entrar
                    CustomButton(
                      text: 'Entrar',
                      onPressed: () {},
                      isPrimary: true,
                    ),
                    const SizedBox(height: 16),
                    // Botão Cadastrar
                    CustomButton(
                      text: 'Cadastrar',
                      onPressed: () {},
                      isPrimary: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Rodapé fixo
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '2025 © EVOLVERE',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

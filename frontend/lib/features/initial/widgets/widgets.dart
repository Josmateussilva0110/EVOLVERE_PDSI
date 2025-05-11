import 'package:flutter/material.dart';
import '../components/components.dart';
import '../themes/themes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Theme(
      data: AppThemes.lightTheme,
      child: Scaffold(
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
                      Image.asset(
                        'assets/images/new_initial/image 5.png',
                        height: size.height * 0.18,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Bem-vindo(A)!',
                        style: TextStyle(
                          color: Colors.white, // ou qualquer outra cor
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),
                      Text(
                        'Construa hábitos reais. Um dia de cada vez.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        text: 'Entrar',
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        isPrimary: true,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Cadastrar',
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastro_usuario');
                        },
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '2025 © EVOLVERE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

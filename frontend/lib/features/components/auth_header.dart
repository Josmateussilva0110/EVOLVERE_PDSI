import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 40.0,
      ), // Padding superior e inferior
      decoration: BoxDecoration(
        color: Colors.black, // Alterado para preto para harmonizar com o fundo
        // Removendo o borderRadius para um visual mais limpo e sem quebras
        // Removendo o boxShadow para um visual mais minimalista
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Removendo o texto "Evolvere" para um visual mais limpo e focado no título
          // const SizedBox(height: 10), // Espaço entre o nome e o título
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ), // Usando TextStyle padrão
          ),
        ],
      ),
    );
  }
}

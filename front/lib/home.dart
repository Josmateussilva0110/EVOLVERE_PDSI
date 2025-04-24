import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String email;
  final String token;

  const HomePage({required this.email, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Usuário logado: $email'),
            SizedBox(height: 10),
            Text('Token: $token'),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Sair'),
              onPressed: () {
                Navigator.pop(context); // Volta para HomeMenu
              },
            ),
          ],
        ),
      ),
    );
  }
}

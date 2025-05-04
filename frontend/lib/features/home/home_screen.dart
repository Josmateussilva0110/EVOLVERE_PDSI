import 'package:flutter/material.dart';
import 'tela_perfil.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TelaPerfil(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Welcome to Home Screen'),
      ),
    );
  }
}
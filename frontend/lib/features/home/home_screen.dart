import 'package:flutter/material.dart';
import 'tela_perfil.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaPerfil()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listar_categorias');
              },
              child: const Text('Lista de Categorias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listar_habitos');
              },
              child: const Text('Lista de hábitos'),
            ),
          ],
        ),
      ),
    );
  }
}

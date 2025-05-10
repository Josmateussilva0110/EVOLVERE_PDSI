import 'package:flutter/material.dart';
import '../components/category_list.dart';

class ListCategoryScreen extends StatelessWidget {
  const ListCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217), // Adicionada cor de fundo
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0, // Remove a sombra
        title: const Text(
          'Listar categoria',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.archive,
              color: Colors.white,
            ), // Ícone de arquivo
            onPressed: () {
              // Aqui você pode adicionar a navegação para a tela de arquivados
              // Por exemplo:
              // Navigator.pushNamed(context, '/categorias_arquivadas');
            },
          ),
        ],
      ),
      body: const CategoryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cadastro_categoria'),
        backgroundColor: const Color(0xFF2B6BED),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

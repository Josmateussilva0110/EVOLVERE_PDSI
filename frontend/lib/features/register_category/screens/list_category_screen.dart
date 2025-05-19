import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../components/category_list.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  void _showArchivedCategories() async {
    try {
      final archivedCategories = await CategoryService.getArchivedCategories();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF121217),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (context) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categorias Arquivadas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  if (archivedCategories.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Nenhuma categoria arquivada',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: archivedCategories.length,
                        itemBuilder: (context, index) {
                          final category = archivedCategories[index];
                          return ListTile(
                            title: Text(
                              category.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              category.description,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: category.color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  category.iconUrl != null &&
                                          category.iconUrl.isNotEmpty
                                      ? Image.network(
                                        '${dotenv.env['API_URL']}${category.iconUrl}',
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.folder,
                                                  color: Colors.white,
                                                ),
                                      )
                                      : const Icon(
                                        Icons.folder,
                                        color: Colors.white,
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar categorias arquivadas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Listar categoria',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/inicio'),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.archive,
              color: Colors.white, // Mantendo a cor branca
            ),
            onPressed: _showArchivedCategories,
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

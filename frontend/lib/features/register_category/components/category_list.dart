import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../widgets/category_list_item.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => CategoryListState();
}

class CategoryListState extends State<CategoryList> {
  List<Category> _categories = [];
  List<Category> _archivedCategories =
      []; // Nova lista para categorias arquivadas
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      print('Iniciando carregamento das categorias...'); // Debug
      final categories = await CategoryService.getCategories();
      print('Categorias carregadas: ${categories.length}'); // Debug

      // Separa as categorias ativas e arquivadas
      final activeCategories =
          categories.where((category) => !category.archived).toList();
      final archivedCategories =
          categories.where((category) => category.archived).toList();

      // Debug - imprime cada categoria ativa
      activeCategories.forEach((category) {
        print('Categoria ativa: ${category.name}, ID: ${category.id}');
      });

      setState(() {
        _categories = activeCategories;
        _archivedCategories = archivedCategories;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e'); // Debug
      setState(() {
        _categories = [];
        _archivedCategories = [];
        _isLoading = false;
      });
    }
  }

  void _showArchivedCategories() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
                if (_archivedCategories.isEmpty)
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
                      itemCount: _archivedCategories.length,
                      itemBuilder: (context, index) {
                        final category = _archivedCategories[index];
                        return CategoryListItem(
                          category: category,
                          onCategoryDeleted: () {
                            loadCategories();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child:
              _categories.isEmpty
                  ? const Center(
                    child: Text(
                      'Nenhuma categoria ativa',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                  : RefreshIndicator(
                    onRefresh: loadCategories,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return CategoryListItem(
                          category: category,
                          onCategoryDeleted: () async {
                            await loadCategories();
                          },
                          onEdit: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/editar_categoria',
                              arguments: category,
                            );
                            if (result == true) {
                              await loadCategories();
                            }
                          },
                        );
                      },
                    ),
                  ),
        ),
      ],
    );
  }
}

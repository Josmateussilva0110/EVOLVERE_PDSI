import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../widgets/category_list_item.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      print('Iniciando carregamento das categorias...'); // Debug
      final categories = await CategoryService.getCategories();
      print('Categorias carregadas: ${categories.length}'); // Debug

      // Debug - imprime cada categoria
      categories.forEach((category) {
        print('Categoria: ${category.name}, ID: ${category.id}');
      });

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e'); // Debug
      setState(() {
        _categories = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categories.isEmpty) {
      return const Center(child: Text('Nenhuma categoria encontrada'));
    }

    return RefreshIndicator(
      onRefresh: _loadCategories,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          print('Construindo item: ${category.name}'); // Debug
          return CategoryListItem(category: category);
        },
      ),
    );
  }
}

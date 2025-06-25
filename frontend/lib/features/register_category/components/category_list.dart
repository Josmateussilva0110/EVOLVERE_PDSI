import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../widgets/category_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => CategoryListState();
}

class CategoryListState extends State<CategoryList> {
  List<Category> _categories = []; // Nova lista para categorias arquivadas
  bool _isLoading = true;
  int? _userId;

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      await loadCategories(); 
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> loadCategories() async {
    try {
      final categories = await CategoryService.getCategories(_userId!);
      // Separa as categorias ativas e arquivadas
      final activeCategories =
          categories.where((category) => !category.archived).toList();

      setState(() {
        _categories = activeCategories;
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

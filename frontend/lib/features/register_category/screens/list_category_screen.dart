import 'package:flutter/material.dart';
import '../components/category_list.dart';
import '../components/archived_category_modal.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  final GlobalKey<CategoryListState> _categoryListKey = GlobalKey<CategoryListState>();
  
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
            onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF121217),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return ArchivedCategoryModal(
                              onCategoryRestoredOrDeleted: () {
                                _categoryListKey.currentState?.loadCategories();
                              },
                            );
                          },
                        );
                      },
          ),
        ],
      ),
      body: CategoryList(key: _categoryListKey),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/cadastro_categoria');
            if (result == true) {
              _categoryListKey.currentState?.loadCategories();
            }
          },
          backgroundColor: Colors.grey[300], // CINZA CLARO
          child: const Icon(Icons.add, color: Colors.black, size: 32),
        ),
    );
  }
}
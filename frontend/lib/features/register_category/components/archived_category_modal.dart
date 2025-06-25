import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchivedCategoryModal extends StatefulWidget {
  final VoidCallback onCategoryRestoredOrDeleted;

  const ArchivedCategoryModal({super.key, required this.onCategoryRestoredOrDeleted});

  @override
  State<ArchivedCategoryModal> createState() => _ArchivedCategoryModalState();
}

class _ArchivedCategoryModalState extends State<ArchivedCategoryModal> {
  bool isLoading = true;
  List<Category> archivedCategories = [];
  int? _userId;

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      await _loadArchived();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadArchived() async {
    archivedCategories = await CategoryService.getArchivedCategories(_userId!);
    setState(() => isLoading = false);
  }

  Future<void> _restoreCategory(Category category) async {
    final success = await CategoryService.restoreCategory(category.id);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoria restaurada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onCategoryRestoredOrDeleted();
      await _loadArchived();
    } else {
      _showError('Erro ao restaurar categoria');
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121217),
        title: const Text('Excluir categoria', style: TextStyle(color: Colors.white)),
        content: const Text('Realmente deseja excluir?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar', style: TextStyle(color: Colors.white70))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await CategoryService.deleteCategory(category.id);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoria excluída permanentemente!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onCategoryRestoredOrDeleted();
      await _loadArchived();
    } else {
      _showError('Erro ao excluir categoria');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorias Arquivadas',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (archivedCategories.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.archive_outlined, size: 48, color: Colors.white38),
                  SizedBox(height: 16),
                  Text('Nenhuma categoria arquivada', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  Text('As categorias arquivadas aparecerão aqui', style: TextStyle(color: Colors.white54)),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: archivedCategories.length,
                itemBuilder: (context, index) {
                  final category = archivedCategories[index];
                  return ListTile(
                    title: Text(category.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(category.description, style: const TextStyle(color: Colors.white70)),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: category.iconUrl.isNotEmpty
                          ? Image.network(
                              '${dotenv.env['API_URL']}${category.iconUrl}',
                              errorBuilder: (_, __, ___) => const Icon(Icons.folder, color: Colors.white),
                            )
                          : const Icon(Icons.folder, color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.restore, color: Colors.green), onPressed: () => _restoreCategory(category)),
                        IconButton(icon: const Icon(Icons.delete_forever, color: Colors.red), onPressed: () => _deleteCategory(category)),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
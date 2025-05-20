import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../components/category_list.dart';
import '../services/category_service.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  final GlobalKey<CategoryListState> _categoryListKey = GlobalKey<CategoryListState>();

  void _showArchivedCategories() async {
    List<Category> archivedCategories = [];
    bool isLoading = true;
    Future<void> loadArchived() async {
      archivedCategories = await CategoryService.getArchivedCategories();
      isLoading = false;
      if (mounted) setState(() {});
    }

    await loadArchived();
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> reloadModal() async {
              isLoading = true;
              setModalState(() {});
              archivedCategories =
                  await CategoryService.getArchivedCategories();
              isLoading = false;
              setModalState(() {});
            }

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Container(
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
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (archivedCategories.isEmpty)
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.archive_outlined,
                                size: 48,
                                color: Colors.white38,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma categoria arquivada',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'As categorias arquivadas aparecerão aqui',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.restore,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      try {
                                        final response = await http.patch(
                                          Uri.parse(
                                            '${dotenv.env['API_URL']}/category/${category.id}/unarchive',
                                          ),
                                        );
                                        if (response.statusCode == 200) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Categoria restaurada com sucesso!',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          await reloadModal();
                                          _categoryListKey.currentState?.loadCategories();
                                        } else {
                                          throw Exception(
                                            'Falha ao restaurar categoria',
                                          );
                                        }
                                      } catch (e) {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Erro ao restaurar categoria',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: const Color(0xFF121217),
                                          title: const Text(
                                            'Excluir categoria',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                            'Realmente deseja excluir?',
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm != true) return;
                                      try {
                                        final response = await http.delete(
                                          Uri.parse(
                                            '${dotenv.env['API_URL']}/category/${category.id}',
                                          ),
                                        );
                                        if (response.statusCode == 200) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Categoria excluída permanentemente!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          await reloadModal();
                                          _categoryListKey.currentState?.loadCategories();
                                        } else {
                                          throw Exception('Falha ao excluir categoria');
                                        }
                                      } catch (e) {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Erro ao excluir categoria'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
      body: CategoryList(key: _categoryListKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cadastro_categoria'),
        backgroundColor: const Color(0xFF2B6BED),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

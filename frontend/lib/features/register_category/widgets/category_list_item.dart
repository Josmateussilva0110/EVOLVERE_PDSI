import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../screens/CategoryDetailScreen.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onCategoryDeleted;
  final Future<void> Function()? onEdit;

  const CategoryListItem({
    Key? key,
    required this.category,
    this.onCategoryDeleted,
    this.onEdit,
  }) : super(key: key);

  Future<void> _deleteCategory(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/category/${category.id}'),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        if (onCategoryDeleted != null) onCategoryDeleted!();
      } else {
        throw Exception('Falha ao excluir categoria');
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao excluir categoria'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _archiveCategory(BuildContext context) async {
    try {
      final response = await http.patch(
        Uri.parse('${dotenv.env['API_URL']}/category/${category.id}/archive'),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria arquivada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        if (onCategoryDeleted != null) onCategoryDeleted!();
      } else {
        throw Exception('Falha ao arquivar categoria');
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao arquivar categoria'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: Text(
                'Editar categoria',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                if (onEdit != null) {
                  await onEdit!();
                } else {
                  await Navigator.pushNamed(
                    context,
                    '/editar_categoria',
                    arguments: category,
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: Colors.amber),
              title: Text(
                'Arquivar categoria',
                style: GoogleFonts.inter(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF121217),
                    title: Text(
                      'Arquivar categoria',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Deseja realmente arquivar esta categoria?',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _archiveCategory(context),
                        child: Text(
                          'Arquivar',
                          style: GoogleFonts.inter(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: Text(
                'Excluir categoria',
                style: GoogleFonts.inter(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF121217),
                    title: Text(
                      'Excluir categoria',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Deseja realmente excluir esta categoria?',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _deleteCategory(context),
                        child: Text(
                          'Excluir',
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(category: category),
          ),
        );
      },
      onLongPress: () => _showOptions(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E24),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Padding( // <-- ALTERAÇÃO APLICADA AQUI
                padding: const EdgeInsets.all(8.0), // Você pode ajustar este valor
                child: category.iconUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          '${dotenv.env['API_URL']}${category.iconUrl}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.category, color: category.color),
                        ),
                      )
                    : Icon(Icons.category, color: category.color, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
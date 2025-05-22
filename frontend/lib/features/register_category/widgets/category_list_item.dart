import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

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

      if (response.statusCode == 200) {
        // Fecha o dialog
        Navigator.pop(context);

        // Mostra mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Atualiza a lista de categorias
        // Você pode implementar um callback para atualizar a lista
        if (onCategoryDeleted != null) {
          onCategoryDeleted!();
        }
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

      if (response.statusCode == 200) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria arquivada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        if (onCategoryDeleted != null) {
          onCategoryDeleted!();
        }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF121217),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder:
              (context) => Container(
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
                          builder:
                              (context) => AlertDialog(
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
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
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
                          builder:
                              (context) => AlertDialog(
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
                                    onPressed: () {
                                      _deleteCategory(context);
                                    },
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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: category.color.withOpacity(0.3)),
        ),
        child: ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: const Color(0xFF121217),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.name,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          category.description,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Fechar',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          leading: ClipOval(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: category.color.withOpacity(0.2)),
              child:
                  category.iconUrl.isNotEmpty
                      ? Image.network(
                        '${dotenv.env['API_URL']}${category.iconUrl}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.category, color: category.color);
                        },
                      )
                      : Icon(Icons.category, color: category.color),
            ),
          ),
          title: Text(
            category.name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            category.description,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

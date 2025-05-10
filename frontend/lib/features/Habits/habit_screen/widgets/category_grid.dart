import 'package:flutter/material.dart';
import 'category_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryGrid extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final VoidCallback? onAddCategory;

  const CategoryGrid({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onAddCategory,
  }) : super(key: key);

  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
  try {
    final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/categories'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['categories'];

      setState(() {
        categories = data.map<Map<String, dynamic>>((item) => {
          'icon': item['icon'] != null ? '${dotenv.env['API_URL']}${item['icon']}' : '',
          'label': item['name'] ?? 'Sem nome', 
          'category': item['id']?.toString() ?? '', 
          'description': item['description'] ?? '', 
          'color': _parseColor(item['color']),
        }).toList();

        categories.add({
          'icon': Icons.add, 
          'label': 'Mais',
          'category': 'mais',
        });
      });
    } else {
      print('Erro ao carregar categorias: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isAddButton = category['category'] == 'mais';

        return CategoryButton(
          icon: _buildIcon(category['icon']),
          label: category['label'] as String,
          category: category['category'] as String,
          isSelected: widget.selectedCategory == category['category'],
          onSelect: (selected) {
            if (isAddButton && widget.onAddCategory != null) {
              widget.onAddCategory!();
            } else {
              widget.onCategorySelected(selected);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildIcon(dynamic icon) {
  if (icon is IconData) {
    return Icon(icon, color: Colors.white);
  }

  if (icon == null || icon.isEmpty) {
    return Icon(Icons.category, color: Colors.white,);
  }

  Uri? uri = Uri.tryParse(icon);
  if (uri != null && uri.hasAbsolutePath) {
    return ClipOval(
      child: Image.network(
        icon,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image); 
        },
      ),
    );
  }

  return Icon(_mapIcon(icon));
}


IconData _mapIcon(String iconName) {
  switch (iconName) {
    case 'book':
      return Icons.book;
    case 'edit':
      return Icons.edit;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'headphones':
      return Icons.headphones;
    case 'favorite':
      return Icons.favorite;
    default:
      return Icons.category; // retorna um ícone padrão
  }
}


  Color? _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}

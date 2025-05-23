import 'package:flutter/material.dart';
import 'category_button.dart';
import '../../services/category_service.dart';

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
    List<Map<String, dynamic>> loadedCategories =
        await CategoryService.fetchCategories();

    loadedCategories.add({
      'icon': Icons.add,
      'label': 'Mais',
      'category': 'mais',
    });

    setState(() {
      categories = loadedCategories;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          categories.map((category) {
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
    const double iconSize = 32;

    if (icon is IconData) {
      return Icon(icon, color: Colors.white, size: iconSize);
    }

    if (icon == null || icon.isEmpty) {
      return Icon(Icons.category, color: Colors.white, size: iconSize);
    }

    Uri? uri = Uri.tryParse(icon);
    if (uri != null && uri.hasAbsolutePath) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: ClipOval(
          child: Image.network(
            icon,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, size: iconSize);
            },
          ),
        ),
      );
    }

    return Icon(_mapIcon(icon), color: Colors.white, size: iconSize);
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
}

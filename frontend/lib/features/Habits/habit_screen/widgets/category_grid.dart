import 'package:flutter/material.dart';
import 'category_button.dart';
import '../../services/category_service.dart';

class CategoryGrid extends StatefulWidget {
  final int? selectedCategory;
  final ValueChanged<int?> onCategorySelected;
  final Future<bool> Function()? onAddCategory;

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
    List<Map<String, dynamic>> loadedCategories = await CategoryService.fetchCategories();
    loadedCategories = loadedCategories.map((cat) {
    final catValue = cat['category'];
    int? catInt;
    if (catValue is int) {
      catInt = catValue;
    } else if (catValue is String) {
      catInt = int.tryParse(catValue);
    }
    return {
      ...cat,
      'category': catInt,
    };
  }).toList();

  final addCategoryButton = {
    'icon': Icons.add,
    'label': 'Mais',
    'category': null,
  };

  setState(() {
    categories = [...loadedCategories, addCategoryButton];
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
            final isAddButton = category['category'] == null;

            return CategoryButton(
              icon: _buildIcon(category['icon']),
              label: category['label'] as String,
              category: category['category'],  
              isSelected: widget.selectedCategory != null &&
                          widget.selectedCategory == category['category'],
              onSelect: (selected) async {
                if (isAddButton && widget.onAddCategory != null) {
                  final result = await widget.onAddCategory!();
                  if (result == true) {
                    _fetchCategories();
                  }
                } else {
                  if (selected is int) {
                    widget.onCategorySelected(selected);
                  }
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

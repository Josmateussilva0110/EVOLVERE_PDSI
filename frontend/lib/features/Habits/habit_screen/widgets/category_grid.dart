import 'package:flutter/material.dart';
import 'category_button.dart';

class CategoryGrid extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryGrid({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: _buildCategoryButtons());
  }

  List<Widget> _buildCategoryButtons() {
    final categories = [
      {'icon': Icons.edit, 'label': 'Escrita', 'category': 'escrita'},
      {'icon': Icons.book, 'label': 'Leitura', 'category': 'leitura'},
      {'icon': Icons.fitness_center, 'label': 'Fitness', 'category': 'fitness'},
      {'icon': Icons.headphones, 'label': 'Audição', 'category': 'audicao'},
      {'icon': Icons.favorite, 'label': 'Bem-estar', 'category': 'bem-estar'},
      {'icon': Icons.add, 'label': 'Mais', 'category': 'mais'},
    ];

    return categories.map((category) {
      return CategoryButton(
        icon: category['icon'] as IconData,
        label: category['label'] as String,
        category: category['category'] as String,
        isSelected: selectedCategory == category['category'],
        onSelect: onCategorySelected,
      );
    }).toList();
  }
}

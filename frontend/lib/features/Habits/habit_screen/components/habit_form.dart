import 'package:flutter/material.dart';
import 'package:front/features/habits/components/app_header.dart';
import '../widgets/habit_text_field.dart';
import '../widgets/category_grid.dart';

class HabitForm extends StatelessWidget {
  final String habitName;
  final String description;
  final String selectedCategory;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final Function(String) onCategorySelected;

  const HabitForm({
    Key? key,
    required this.habitName,
    required this.description,
    required this.selectedCategory,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HabitTextField(
          label: 'Nome do Habito',
          hint: 'ex: Aprender um Idioma',
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 24),
        HabitTextField(
          label: 'Descrição',
          hint: 'Opcional',
          onChanged: onDescriptionChanged,
        ),
        SizedBox(height: 32),
        Appbody(title: 'Categoria',),
        SizedBox(height: 16),
        CategoryGrid(
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:front/features/habits/components/app_header.dart';
import '../widgets/habit_text_field.dart';
import '../widgets/category_grid.dart';

class HabitForm extends StatefulWidget {
  final String habitName;
  final String description;
  final int? selectedCategory;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<int> onCategorySelected;

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
  _HabitFormState createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habitName);
    _descriptionController = TextEditingController(text: widget.description);

    // Prints de depuração
    print('📝 Nome do hábito recebido: ${widget.habitName}');
    print('📄 Descrição recebida: ${widget.description}');
    print('📂 Categoria selecionada: ${widget.selectedCategory}');
  }


  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HabitTextField(
          label: 'Nome do Hábito*',
          hint: 'ex: Aprender um Idioma',
          controller: _nameController,
          onChanged: widget.onNameChanged,
        ),
        const SizedBox(height: 24),
        HabitTextField(
          label: 'Descrição',
          hint: 'Opcional',
          controller: _descriptionController,
          onChanged: widget.onDescriptionChanged,
        ),
        const SizedBox(height: 32),
        Appbody(title: 'Categoria'),
        const SizedBox(height: 16),
        CategoryGrid(
          selectedCategory: widget.selectedCategory,
          onCategorySelected: widget.onCategorySelected,
          onAddCategory: () {
            Navigator.pushNamed(context, '/cadastro_categoria');
          },
        ),
      ],
    );
  }
}

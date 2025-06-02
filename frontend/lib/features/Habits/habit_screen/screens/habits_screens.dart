import 'package:flutter/material.dart';
import '../themes/habits_theme.dart';
import '../components/habit_form.dart';
import '../widgets/bottom_navigation.dart';
import '../../components/habits_app_bar.dart';
import '../../model/HabitData.dart';

class HabitScreen extends StatefulWidget {
  final HabitData habitData;
  const HabitScreen({Key? key, required this.habitData}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  String habitName = '';
  String description = '';
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    habitName = widget.habitData.habitName;
    description = widget.habitData.description;
    selectedCategory = widget.habitData.selectedCategory;
    print(habitName);
    print(description);
    print(selectedCategory);
  }

  void _onCategorySelected(int category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
  }

  void _goToFrequency() {
    if (habitName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O nome do hábito é obrigatório.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedHabitData = widget.habitData.copyWith(
      habitName: habitName,
      description: description,
      selectedCategory: selectedCategory,
      frequencyData: widget.habitData.frequencyData, 
    );


    Navigator.pushReplacementNamed(
      context,
      '/cadastrar_frequencia',
      arguments: updatedHabitData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitsTheme.backgroundColor,
      appBar: HeaderAppBar(title: 'Novo Hábito'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: HabitForm(
                habitName: habitName,
                description: description,
                selectedCategory: selectedCategory,
                onNameChanged: (value) => setState(() => habitName = value),
                onDescriptionChanged:
                    (value) => setState(() => description = value),
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ),
          BottomNavigation(
            nextRoute: '/cadastrar_frequencia',
            onNext: _goToFrequency,
          ),
        ],
      ),
    );
  }
}

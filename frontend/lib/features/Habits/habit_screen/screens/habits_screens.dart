import 'package:flutter/material.dart';
import '../themes/habits_theme.dart';
import '../components/habit_form.dart';
import '../widgets/bottom_navigation.dart';
import '../../components/habits_app_bar.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({Key? key}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  String habitName = '';
  String description = '';
  String selectedCategory = '';

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? '' : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitsTheme.backgroundColor,
      appBar: HeaderAppBar(title: 'Novo Hábito',),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
          BottomNavigation(nextRoute: '/cadastrar_frequencia'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/habits_theme.dart';
import '../components/habit_form.dart';
import '../widgets/bottom_navigation.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Novo Hábito',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
          BottomNavigation(nextRoute: '/frequencia'),
        ],
      ),
    );
  }
}

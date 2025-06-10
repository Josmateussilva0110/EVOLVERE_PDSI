import 'package:flutter/material.dart';
import '../themes/habits_theme.dart';
import '../components/habit_form.dart';
import '../widgets/bottom_navigation.dart';
import '../../components/habits_app_bar.dart';
import '../../model/HabitData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitScreen extends StatefulWidget {
  final HabitData habitData;
  const HabitScreen({Key? key, required this.habitData}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  int? habitId;
  int? userId;
  String habitName = '';
  String description = '';
  int? selectedCategory;
  Map<String, dynamic> frequencyData = {};

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('loggedInUserId');
    });
  }


  @override
  void initState() {
    super.initState();
    habitId = widget.habitData.habitId;
    userId = widget.habitData.userId;
    habitName = widget.habitData.habitName;
    description = widget.habitData.description;
    selectedCategory = widget.habitData.selectedCategory;
    frequencyData = Map.from(widget.habitData.frequencyData);
    if (selectedCategory is String) {
      selectedCategory = int.tryParse(selectedCategory as String);
    }
    _loadUserId();
  }

  void _onFrequencyDataChanged(Map<String, dynamic> newData) {
    setState(() {
      frequencyData = newData;
    });
  }

  void _onCategorySelected(int? category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = null;
      } else {
        selectedCategory = category;
      }
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
      habitId: habitId,
      userId: userId,
      habitName: habitName,
      description: description,
      selectedCategory: selectedCategory,
      frequencyData: frequencyData,
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
                habitId: habitId,
                habitName: habitName,
                description: description,
                selectedCategory: selectedCategory,
                onNameChanged: (value) => setState(() => habitName = value),
                onDescriptionChanged:
                    (value) => setState(() => description = value),
                onCategorySelected: _onCategorySelected,
                onFrequencyDataChanged: _onFrequencyDataChanged,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../listHabits/models/HabitModel.dart';
import '../model/Finish_habit_model.dart';
import '../service/finish_habit_service.dart';
import '../components/finish_habit_form.dart';


class FinishHabitScreen extends StatefulWidget {
  final Habit habit;

  const FinishHabitScreen({super.key, required this.habit});

  @override
  State<FinishHabitScreen> createState() => _FinishHabitScreenState();
}

class _FinishHabitScreenState extends State<FinishHabitScreen> {
  int _selectedDifficulty = 0; // 0: Fácil, 1: Médio, 2: Difícil
  int _selectedMood = 0; // 0: Neutro, 1: Motivado, 2: Desanimado
  final TextEditingController _reflectionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  int _hours = 0;
  int _minutes = 0;

  @override
  void dispose() {
    _reflectionController.dispose();
    _locationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF808080)),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/listar_habitos',
                (route) => false,
              );
            },
          ),
          title: Text(
            'Finalizar Hábito',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FinishHabitForm(
                selectedDifficulty: _selectedDifficulty,
                selectedMood: _selectedMood,
                reflectionController: _reflectionController,
                locationController: _locationController,
                hours: _hours,
                minutes: _minutes,
                onSelectDifficulty: (int selected) {
                  setState(() {
                    _selectedDifficulty = selected;
                  });
                },
                onSelectMood: (int selected) {
                  setState(() {
                    _selectedMood = selected;
                  });
                },
                onPickTime: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: _hours, minute: _minutes),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            surface: Color(0xFF232B3E),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xFF10182B),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _hours = pickedTime.hour;
                      _minutes = pickedTime.minute;
                    });
                  }
                },
                onReflectionChanged: (text) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_hours == 0 && _minutes == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'O tempo dedicado não pode ser zero.',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                      return;
                    }

                    final habitData = FinishHabitData(
                      habitId: widget.habit.id,
                      difficulty: _selectedDifficulty,
                      mood: _selectedMood,
                      reflection: _reflectionController.text.trim(),
                      location: _locationController.text.trim(),
                      hour: TimeOfDay(hour: _hours, minute: _minutes),
                    );

                    final result = await FinishHabitService.createFinishHabit(
                      habitData,
                    );

                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cadastro realizado com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacementNamed(
                        context,
                        '/listar_habitos',
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result,
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

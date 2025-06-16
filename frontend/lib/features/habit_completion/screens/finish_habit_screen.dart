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

  bool _isTimeValid() {
    return !(_hours == 0 && _minutes == 0);
  }

  Widget _buildDifficultyChip(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDifficulty = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color:
                _selectedDifficulty == index
                    ? const Color(0xFF1E3A5F)
                    : const Color(0xFF141414),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  _selectedDifficulty == index
                      ? const Color(0xFF4A90E2)
                      : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color:
                    _selectedDifficulty == index
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF808080),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodOption(String label, IconData iconData, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = index;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    _selectedMood == index
                        ? const Color(0xFF4A90E2)
                        : Colors.transparent,
                width: _selectedMood == index ? 2 : 0,
              ),
              color: const Color(0xFF141414),
            ),
            child: Icon(
              iconData,
              color:
                  _selectedMood == index
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF808080),
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color:
                  _selectedMood == index
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF808080),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hours, minute: _minutes),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              surface: Color(0xFF1F222A),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4A90E2),
              ),
            ),
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
  }

  Future<void> _submitCompletion() async {
    if (!_isTimeValid()) {
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

    // Removido o código de chamada da API para depuração temporária
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Navegando para a tela de progresso (API ignorada)!'),
    //     backgroundColor: Colors.blue,
    //   ),
    // );

    // Navegar para a tela de registro de progresso e remover todas as rotas anteriores
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/progress_record',
      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
      arguments: widget.habit, // Passa o objeto habit
    );
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

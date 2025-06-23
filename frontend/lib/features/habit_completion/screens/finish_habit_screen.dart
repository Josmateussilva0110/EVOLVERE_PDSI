import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../listHabits/models/HabitModel.dart';
import '../model/Finish_habit_model.dart';
import '../service/finish_habit_service.dart';
import '../components/finish_habit_form.dart';
import '../widgets/reflection_input.dart';
import '../widgets/location_input.dart';

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
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/listar_habitos',
                  (route) => false,
                );
              },
            ),
            title: Text(
              'Finalizar hábito',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Cada passo conta! Compartilhe sua experiência.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),
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
                              surface: Colors.black,
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.black,
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
                const SizedBox(height: 36),
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
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (context) => Dialog(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.celebration,
                                        color: Colors.blue,
                                        size: 56,
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        'Hábito concluído! 🎉',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        'Parabéns por mais uma conquista! Continue assim.',
                                        style: GoogleFonts.inter(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 28),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            'Voltar',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/listar_habitos',
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Salvar',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

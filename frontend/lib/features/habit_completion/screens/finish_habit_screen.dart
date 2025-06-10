import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../listHabits/models/HabitModel.dart';
import '../../listHabits/screens/progress_record_screen.dart';

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

  Widget _buildDifficultyChip(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color:
              _selectedDifficulty == index
                  ? Colors.blue.withOpacity(0.2)
                  : const Color(0xFF232B3E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                _selectedDifficulty == index ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (_selectedDifficulty == index)
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: _selectedDifficulty == index ? Colors.blue : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
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
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    _selectedMood == index ? Colors.blue : Colors.transparent,
                width: _selectedMood == index ? 3 : 0,
              ),
              boxShadow: [
                if (_selectedMood == index)
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Icon(
              iconData,
              color: _selectedMood == index ? Colors.blue : Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: _selectedMood == index ? Colors.blue : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF10182B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
              Text(
                'Nível de dificuldade',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDifficultyChip('Fácil 💪', 0),
                  _buildDifficultyChip('Médio 🧠', 1),
                  _buildDifficultyChip('Difícil 🤯', 2),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Humor',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodOption(
                    'Neutro',
                    Icons.sentiment_neutral_rounded,
                    0,
                  ),
                  _buildMoodOption(
                    'Motivado',
                    Icons.sentiment_satisfied_alt_rounded,
                    1,
                  ),
                  _buildMoodOption(
                    'Desanimado',
                    Icons.sentiment_dissatisfied_rounded,
                    2,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Reflexão',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reflectionController,
                maxLines: 4,
                maxLength: 250,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText:
                      'Hoje foi desafiador, mas consegui manter o foco...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF232B3E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  counterText: '${_reflectionController.text.length}/250',
                  counterStyle: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Local da realização',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Casa, Biblioteca, Academia...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF232B3E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tempo dedicado',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: _hours, minute: _minutes),
                    builder: (BuildContext context, Widget? child) {
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232B3E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_hours.toString().padLeft(2, '0')}h ${_minutes.toString().padLeft(2, '0')}min',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time, color: Colors.white70),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProgressRecordScreen(
                              habitName: widget.habit.name,
                              category:
                                  widget.habit.categoryName ?? 'Sem Categoria',
                              totalMinutes: _hours * 60 + _minutes,
                              dailyAverage: 'N/A',
                              currentStreak: 'N/A',
                              monthDays: 'N/A',
                              progressPercent: 0.0,
                              weeklyData: [],
                            ),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/listar_habitos',
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.white38, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/mood_option.dart';
import '../widgets/difficulty_chip.dart';
import '../widgets/reflection_input.dart';
import '../widgets/location_input.dart';
import '../widgets/time_selector.dart';

class FinishHabitForm extends StatelessWidget {
  final int selectedDifficulty;
  final int selectedMood;
  final TextEditingController reflectionController;
  final TextEditingController locationController;
  final int hours;
  final int minutes;
  final Function(int) onSelectDifficulty;
  final Function(int) onSelectMood;
  final VoidCallback onPickTime;
  final Function(String) onReflectionChanged;

  const FinishHabitForm({
    super.key,
    required this.selectedDifficulty,
    required this.selectedMood,
    required this.reflectionController,
    required this.locationController,
    required this.hours,
    required this.minutes,
    required this.onSelectDifficulty,
    required this.onSelectMood,
    required this.onPickTime,
    required this.onReflectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Nível de dificuldade'),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            final labels = ['Fácil', 'Médio', 'Difícil'];
            return DifficultyChip(
              label: labels[index],
              index: index,
              selectedDifficulty: selectedDifficulty,
              onTap: onSelectDifficulty,
            );
          }),
        ),
        const SizedBox(height: 32),
        sectionTitle('Humor'),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MoodOption(
              label: 'Motivado',
              index: 1,
              selectedMood: selectedMood,
              onTap: onSelectMood,
            ),
            MoodOption(
              label: 'Neutro',
              index: 0,
              selectedMood: selectedMood,
              onTap: onSelectMood,
            ),
            MoodOption(
              label: 'Desanimado',
              index: 2,
              selectedMood: selectedMood,
              onTap: onSelectMood,
            ),
          ],
        ),
        const SizedBox(height: 32),
        sectionTitle('Reflexão'),
        const SizedBox(height: 14),
        ReflectionInput(
          controller: reflectionController,
          onChanged: onReflectionChanged,
        ),
        const SizedBox(height: 32),
        sectionTitle('Local da realização'),
        const SizedBox(height: 14),
        LocationInput(controller: locationController),
        const SizedBox(height: 32),
        sectionTitle('Tempo dedicado'),
        const SizedBox(height: 14),
        TimeSelector(hours: hours, minutes: minutes, onTap: onPickTime),
      ],
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

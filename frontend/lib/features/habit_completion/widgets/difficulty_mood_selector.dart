import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultyMoodSelector extends StatelessWidget {
  final int selectedDifficulty;
  final int selectedMood;
  final void Function(int difficulty, int mood) onSelect;

  const DifficultyMoodSelector({
    super.key,
    required this.selectedDifficulty,
    required this.selectedMood,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final List<_DifficultyMoodOption> options = [
      _DifficultyMoodOption(
        label: 'Fácil & Motivado',
        emoji: '😃',
        icon: Icons.sentiment_satisfied_alt_rounded,
        difficulty: 0,
        mood: 1,
      ),
      _DifficultyMoodOption(
        label: 'Médio & Neutro',
        emoji: '😐',
        icon: Icons.sentiment_neutral_rounded,
        difficulty: 1,
        mood: 0,
      ),
      _DifficultyMoodOption(
        label: 'Difícil & Desanimado',
        emoji: '😣',
        icon: Icons.sentiment_dissatisfied_rounded,
        difficulty: 2,
        mood: 2,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          options.map((option) {
            final bool isSelected =
                selectedDifficulty == option.difficulty &&
                selectedMood == option.mood;
            return GestureDetector(
              onTap: () => onSelect(option.difficulty, option.mood),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.blue.withOpacity(0.12)
                          : const Color(0xFF181818),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(option.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 6),
                    Icon(
                      option.icon,
                      color: isSelected ? Colors.blue : Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.label,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.blue : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _DifficultyMoodOption {
  final String label;
  final String emoji;
  final IconData icon;
  final int difficulty;
  final int mood;

  _DifficultyMoodOption({
    required this.label,
    required this.emoji,
    required this.icon,
    required this.difficulty,
    required this.mood,
  });
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/habits_theme.dart';

class HabitTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String) onChanged;

  const HabitTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: HabitsTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: HabitsTheme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: HabitsTheme.borderColor),
          ),
          child: TextField(
            style: GoogleFonts.inter(
              color: HabitsTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: HabitsTheme.secondaryTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
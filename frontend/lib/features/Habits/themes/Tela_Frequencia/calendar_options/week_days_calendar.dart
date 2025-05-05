import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../frequency_theme.dart';

class WeekDaysCalendar extends StatelessWidget {
  final List<String> selectedDays;
  final Function(List<String>) onDaysSelected;

  const WeekDaysCalendar({
    Key? key,
    required this.selectedDays,
    required this.onDaysSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: FrequencyTheme.accentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Alguns dias da semana',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildWeekDayOption('Segunda-feira'),
          _buildWeekDayOption('Terça-feira'),
          _buildWeekDayOption('Quarta-feira'),
          _buildWeekDayOption('Quinta-feira'),
          _buildWeekDayOption('Sexta-feira'),
          _buildWeekDayOption('Sábado'),
          _buildWeekDayOption('Domingo'),
        ],
      ),
    );
  }

  Widget _buildWeekDayOption(String day) {
    final isSelected = selectedDays.contains(day);

    return InkWell(
      onTap: () {
        final newSelection = List<String>.from(selectedDays);
        if (isSelected) {
          newSelection.remove(day);
        } else {
          newSelection.add(day);
        }
        onDaysSelected(newSelection);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isSelected
                          ? FrequencyTheme.accentColor
                          : const Color(0xFF3B4254),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  isSelected
                      ? Icon(
                        Icons.check,
                        size: 16,
                        color: FrequencyTheme.accentColor,
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Text(
              day,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/Tela_Frequencia/frequency_theme.dart';
import '../../components/Tela_Frequencia/week_days_picker_widget.dart';
import '../../components/Tela_Frequencia/month_days_picker_widget.dart';
import '../../components/Tela_Frequencia/year_days_picker_widget.dart';
import '../../components/Tela_Frequencia/period_picker_widget.dart';
import '../../components/Tela_Frequencia/repeat_picker_widget.dart';

class FrequencyPickers {
  static void showWeekDaysPicker(
    BuildContext context,
    List<String> selectedDays,
    Function(List<String>) onDaysSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => WeekDaysPickerWidget(
            selectedDays: selectedDays,
            onDaysSelected: onDaysSelected,
          ),
    );
  }

  static void showMonthDaysPicker(
    BuildContext context,
    List<int> selectedDays,
    Function(List<int>) onDaysSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => MonthDaysPickerWidget(
            selectedDays: selectedDays,
            onDaysSelected: onDaysSelected,
          ),
    );
  }

  static void showYearDaysPicker(
    BuildContext context,
    List<DateTime> selectedDates,
    Function(List<DateTime>) onDatesSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => YearDaysPickerWidget(
            selectedDates: selectedDates,
            onDatesSelected: onDatesSelected,
          ),
    );
  }

  static void showPeriodPicker(
    BuildContext context,
    int times,
    String period,
    Function(int, String) onPeriodSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => PeriodPickerWidget(
            times: times,
            period: period,
            onPeriodSelected: onPeriodSelected,
          ),
    );
  }

  static void showRepeatPicker(
    BuildContext context,
    int days,
    Function(int) onDaysSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) =>
              RepeatPickerWidget(days: days, onDaysSelected: onDaysSelected),
    );
  }
}

class WeekDaysPicker extends StatefulWidget {
  final List<String> selectedDays;
  final Function(List<String>) onChanged;

  const WeekDaysPicker({required this.selectedDays, required this.onChanged});

  @override
  _WeekDaysPickerState createState() => _WeekDaysPickerState();
}

class _WeekDaysPickerState extends State<WeekDaysPicker> {
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Alguns dias da semana',
            style: GoogleFonts.inter(
              color: FrequencyTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildDaysList(),
        ],
      ),
    );
  }

  Widget _buildDaysList() {
    final days = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];

    return Wrap(
      spacing: 8,
      children: days.map((day) => _buildDayCheckbox(day)).toList(),
    );
  }

  Widget _buildDayCheckbox(String day) {
    final isSelected = _selectedDays.contains(day);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(day);
          } else {
            _selectedDays.add(day);
          }
        });
        widget.onChanged(_selectedDays);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? FrequencyTheme.accentColor
                  : FrequencyTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? FrequencyTheme.accentColor
                    : FrequencyTheme.borderColor,
          ),
        ),
        child: Text(
          day,
          style: GoogleFonts.inter(
            color: FrequencyTheme.textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/frequency_theme.dart';

class WeekDaysPickerWidget extends StatefulWidget {
  final List<String> selectedDays;
  final Function(List<String>) onDaysSelected;

  const WeekDaysPickerWidget({
    Key? key,
    required this.selectedDays,
    required this.onDaysSelected,
  }) : super(key: key);

  @override
  State<WeekDaysPickerWidget> createState() => _WeekDaysPickerWidgetState();
}

class _WeekDaysPickerWidgetState extends State<WeekDaysPickerWidget> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          ..._buildWeekDays(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: FrequencyTheme.accentColor, size: 24),
        const SizedBox(width: 12),
        Text(
          'Alguns dias da semana',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildWeekDays() {
    final weekDays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];

    return weekDays.map((day) {
      final isSelected = _selectedDays.contains(day);
      return InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedDays.remove(day);
            } else {
              _selectedDays.add(day);
            }
            widget.onDaysSelected(_selectedDays);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:
                        isSelected
                            ? FrequencyTheme.accentColor
                            : const Color(0xFF3B4254),
                    width: 2,
                  ),
                  color:
                      isSelected
                          ? FrequencyTheme.accentColor
                          : Colors.transparent,
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
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
    }).toList();
  }
}

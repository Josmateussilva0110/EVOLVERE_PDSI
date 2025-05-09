import 'package:flutter/material.dart';
import '../widgets/frequency_option.dart';
import '../widgets/frequency_pickers.dart';

class FrequencyForm extends StatelessWidget {
  final String selectedFrequency;
  final Function(String) onFrequencySelect;

  final List<String> selectedDaysOfWeek;
  final List<int> selectedDaysOfMonth;
  final List<DateTime> selectedYearDays;
  final int repeatTimes;
  final String repeatPeriod;

  final Function(List<String>) onWeekDaysSelected;
  final Function(List<int>) onMonthDaysSelected;
  final Function(List<DateTime>) onYearDaysSelected;
  final Function(int, String) onPeriodSelected;
  final Function(int) onRepeatSelected;

  const FrequencyForm({
    required this.selectedFrequency,
    required this.onFrequencySelect,
    required this.selectedDaysOfWeek,
    required this.selectedDaysOfMonth,
    required this.selectedYearDays,
    required this.repeatTimes,
    required this.repeatPeriod,
    required this.onWeekDaysSelected,
    required this.onMonthDaysSelected,
    required this.onYearDaysSelected,
    required this.onPeriodSelected,
    required this.onRepeatSelected,
  });

  void _handleSelection(BuildContext context, String value) {
    onFrequencySelect(value);

    switch (value) {
      case 'alguns_dias_semana':
        FrequencyPickers.showWeekDaysPicker(
          context,
          selectedDaysOfWeek,
          onWeekDaysSelected,
        );
        break;
      case 'dias_especificos_mes':
        FrequencyPickers.showMonthDaysPicker(
          context,
          selectedDaysOfMonth,
          onMonthDaysSelected,
        );
        break;
      case 'dias_especificos_ano':
        FrequencyPickers.showYearDaysPicker(
          context,
          selectedYearDays,
          onYearDaysSelected,
        );
        break;
      case 'algumas_vezes_periodo':
        FrequencyPickers.showPeriodPicker(
          context,
          repeatTimes,
          repeatPeriod,
          onPeriodSelected,
        );
        break;
      case 'repetir':
        FrequencyPickers.showRepeatPicker(
          context,
          repeatTimes,
          onRepeatSelected,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = {
      'todos_os_dias': 'Todos os dias',
      'alguns_dias_semana': 'Alguns dias da semana',
      'dias_especificos_mes': 'Dias específicos do mês',
      'dias_especificos_ano': 'Dias específicos do ano',
      'algumas_vezes_periodo': 'Algumas vezes por período',
      'repetir': 'Repetir',
    };

    return Column(
      children:
          options.entries.map((entry) {
            return FrequencyOption(
              value: entry.key,
              label: entry.value,
              selectedFrequency: selectedFrequency,
              onSelect: (value) => _handleSelection(context, value),
            );
          }).toList(),
    );
  }
}

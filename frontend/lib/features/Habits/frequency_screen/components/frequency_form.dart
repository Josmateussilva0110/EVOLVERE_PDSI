import 'package:flutter/material.dart';
import '../widgets/frequency_option.dart';
import '../widgets/frequency_pickers.dart';

class FrequencyForm extends StatelessWidget {

  final Map<String, dynamic> frequencyData;
  final Function(Map<String, dynamic>) onFrequencyDataChanged;

  const FrequencyForm({
    Key? key,
    required this.frequencyData,
    required this.onFrequencyDataChanged,
  }) : super(key: key);


  void _handleSelection(BuildContext context, String type) {
  switch (type) {
    case 'alguns_dias_semana':
      FrequencyPickers.showWeekDaysPicker(
        context,
        List<String>.from(frequencyData['valores'] ?? []),
        (days) => onFrequencyDataChanged({'tipo': type, 'valores': days}),
      );
      break;
    case 'dias_especificos_mes':
      FrequencyPickers.showMonthDaysPicker(
        context,
        List<int>.from(frequencyData['valores'] ?? []),
        (days) => onFrequencyDataChanged({'tipo': type, 'valores': days}),
      );
      break;
    case 'dias_especificos_ano':
      FrequencyPickers.showYearDaysPicker(
        context,
        List<DateTime>.from(frequencyData['valores'] ?? []),
        (dates) => onFrequencyDataChanged({'tipo': type, 'valores': dates}),
      );
      break;
    case 'algumas_vezes_periodo':
      FrequencyPickers.showPeriodPicker(
        context,
        frequencyData['valores']?['vezes'] ?? 1,
        frequencyData['valores']?['periodo'] ?? 'SEMANA',
        (vezes, periodo) =>
            onFrequencyDataChanged({'tipo': type, 'valores': {'vezes': vezes, 'periodo': periodo}}),
      );
      break;
    case 'repetir':
      FrequencyPickers.showRepeatPicker(
        context,
        frequencyData['valores'] ?? 1,
        (vezes) => onFrequencyDataChanged({'tipo': type, 'valores': vezes}),
      );
      break;
    default:
      onFrequencyDataChanged({'tipo': type, 'valores': null});
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
              selectedFrequency: frequencyData['tipo'],
              onSelect: (value) => _handleSelection(context, value),
            );
          }).toList(),
    );
  }
}

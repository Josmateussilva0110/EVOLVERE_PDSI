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
        List<String>.from(frequencyData['value'] ?? []),
        (days) => onFrequencyDataChanged({'option': type, 'value': days}),
      );
      break;
    case 'dias_especificos_mes':
      FrequencyPickers.showMonthDaysPicker(
        context,
        List<int>.from(frequencyData['value'] ?? []),
        (days) => onFrequencyDataChanged({'option': type, 'value': days}),
      );
      break;
    case 'dias_especificos_ano':
      FrequencyPickers.showYearDaysPicker(
        context,
        List<DateTime>.from(frequencyData['value'] ?? []),
        (dates) => onFrequencyDataChanged({'option': type, 'value': dates}),
      );
      break;
    case 'algumas_vezes_periodo':
      FrequencyPickers.showPeriodPicker(
        context,
        frequencyData['value']?['vezes'] ?? 1,
        frequencyData['value']?['periodo'] ?? 'SEMANA',
        (vezes, periodo) =>
            onFrequencyDataChanged({'option': type, 'value': {'vezes': vezes, 'periodo': periodo}}),
      );
      break;
    case 'repetir':
      FrequencyPickers.showRepeatPicker(
        context,
        frequencyData['value'] ?? 1,
        (vezes) => onFrequencyDataChanged({'option': type, 'value': vezes}),
      );
      break;
    default:
      onFrequencyDataChanged({'option': type, 'value': null});
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
              selectedFrequency: frequencyData['option'],
              onSelect: (value) => _handleSelection(context, value),
            );
          }).toList(),
    );
  }
}

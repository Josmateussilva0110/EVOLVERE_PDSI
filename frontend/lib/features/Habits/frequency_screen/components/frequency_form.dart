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
        final raw = frequencyData['value'];
        final days = (raw is List && raw.isNotEmpty && raw.first is String)
            ? List<String>.from(raw)
            : <String>[];
        FrequencyPickers.showWeekDaysPicker(
          context,
          days,
          (days) => onFrequencyDataChanged({'option': type, 'value': days}),
        );
        break;
      case 'dias_especificos_mes':
        final raw = frequencyData['value'];
        final days = (raw is List && raw.isNotEmpty && raw.first is int)
            ? List<int>.from(raw)
            : <int>[];

        FrequencyPickers.showMonthDaysPicker(
          context,
          days,
          (days) => onFrequencyDataChanged({'option': type, 'value': days}),
        );
        break;

      case 'dias_especificos_ano':
        final raw = frequencyData['value'];
        final dates = (raw is List && raw.isNotEmpty && raw.first is DateTime)
            ? List<DateTime>.from(raw)
            : <DateTime>[];

        FrequencyPickers.showYearDaysPicker(
          context,
          dates,
          (dates) => onFrequencyDataChanged({'option': type, 'value': dates}),
        );
        break;

      case 'algumas_vezes_periodo':
        final raw = frequencyData['value'];
        final vezes = (raw is Map && raw['vezes'] is int) ? raw['vezes'] as int : 1;
        final periodo = (raw is Map && raw['periodo'] is String) ? raw['periodo'] as String : 'SEMANA';

        FrequencyPickers.showPeriodPicker(
          context,
          vezes,
          periodo,
          (vezes, periodo) => onFrequencyDataChanged({
            'option': type,
            'value': {'vezes': vezes, 'periodo': periodo},
          }),
        );
        break;

      case 'repetir':
        final raw = frequencyData['value'];
        final vezes = (raw is int) ? raw : 1;

        FrequencyPickers.showRepeatPicker(
          context,
          vezes,
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
      children: options.entries.map((entry) {
        return FrequencyOption(
          value: entry.key,
          label: entry.value,
          selectedFrequency: frequencyData['option'],
          onSelect: (value) {
            // Resetar o value ao mudar de opção evita erros
            onFrequencyDataChanged({'option': value, 'value': null});
            _handleSelection(context, value);
          },
        );
      }).toList(),
    );
  }
}

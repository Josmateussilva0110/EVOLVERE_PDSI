import 'package:flutter/material.dart';
import '../widgets/frequency_option.dart';
import '../widgets/frequency_pickers.dart';

class FrequencyForm extends StatefulWidget {
  final Map<String, dynamic> frequencyData;
  final Function(Map<String, dynamic>) onFrequencyDataChanged;

  const FrequencyForm({
    Key? key,
    required this.frequencyData,
    required this.onFrequencyDataChanged,
  }) : super(key: key);

  @override
  _FrequencyFormState createState() => _FrequencyFormState();
}

class _FrequencyFormState extends State<FrequencyForm> {
  @override
  void initState() {
    super.initState();
  }

  void _handleSelection(BuildContext context, String type) {
    switch (type) {
      case 'alguns_dias_semana':
        final raw = widget.frequencyData['value'];
        final days =
            (raw is List && raw.isNotEmpty && raw.first is String)
                ? List<String>.from(raw)
                : <String>[];
        FrequencyPickers.showWeekDaysPicker(
          context,
          days,
          (days) =>
              widget.onFrequencyDataChanged({'option': type, 'value': days}),
        );
        break;

      case 'dias_especificos_mes':
        final raw = widget.frequencyData['value'];
        final days =
            (raw is List && raw.isNotEmpty && raw.first is int)
                ? List<int>.from(raw)
                : <int>[];
        FrequencyPickers.showMonthDaysPicker(
          context,
          days,
          (days) =>
              widget.onFrequencyDataChanged({'option': type, 'value': days}),
        );
        break;

      case 'dias_especificos_ano':
        final raw = widget.frequencyData['value'];
        final dates =
            (raw is List)
                ? raw
                    .map((e) {
                      if (e is DateTime) return e;
                      if (e is String) return DateTime.tryParse(e);
                      return null;
                    })
                    .whereType<DateTime>()
                    .toList()
                : <DateTime>[];

        FrequencyPickers.showYearDaysPicker(
          context,
          dates,
          (dates) =>
              widget.onFrequencyDataChanged({'option': type, 'value': dates}),
        );
        break;

      case 'algumas_vezes_periodo':
        final raw = widget.frequencyData['value'];
        final vezes =
            (raw is Map && raw['vezes'] is int) ? raw['vezes'] as int : 1;
        final periodo =
            (raw is Map && raw['periodo'] is String)
                ? raw['periodo'] as String
                : 'SEMANA';

        FrequencyPickers.showPeriodPicker(
          context,
          vezes,
          periodo,
          (vezes, periodo) => widget.onFrequencyDataChanged({
            'option': type,
            'value': {'vezes': vezes, 'periodo': periodo},
          }),
        );
        break;

      case 'repetir':
        var raw = widget.frequencyData['value'];

        // converter para int
        int vezes = 1;
        if (raw is int && raw > 0) {
          vezes = raw;
        } else if (raw is String) {
          vezes = int.tryParse(raw) ?? 1;
        }

        FrequencyPickers.showRepeatPicker(context, vezes, (novoValor) {
          if (novoValor > 0) {
            widget.onFrequencyDataChanged({'option': type, 'value': novoValor});
          }
        });
        break;

      default:
        widget.onFrequencyDataChanged({'option': type, 'value': null});
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
              selectedFrequency: widget.frequencyData['option'],
              onSelect: (value) {
                if (value == 'repetir') {
                  // Se já existe um valor válido, mantém ele
                  final currentValue = widget.frequencyData['value'];
                  int validValue = 1;

                  if (currentValue is int && currentValue > 0) {
                    validValue = currentValue;
                  } else if (currentValue is String) {
                    final parsed = int.tryParse(currentValue);
                    if (parsed != null && parsed > 0) {
                      validValue = parsed;
                    }
                  }

                  widget.onFrequencyDataChanged({
                    'option': value,
                    'value': validValue,
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _handleSelection(context, value);
                  });
                } else {
                  _handleSelection(context, value);
                }
              },
            );
          }).toList(),
    );
  }
}

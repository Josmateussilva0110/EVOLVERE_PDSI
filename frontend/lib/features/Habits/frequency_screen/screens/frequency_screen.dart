import 'package:flutter/material.dart';
import '../../components/habits_app_bar.dart';
import '../../components/app_header.dart';
import '../themes/frequency_theme.dart';
import '../components/frequency_form.dart';
import '../../components/navigation.dart';
import '../../model/HabitData.dart';

class FrequencyScreen extends StatefulWidget {
  final HabitData habitData;

  const FrequencyScreen({Key? key, required this.habitData}) : super(key: key);

  @override
  _FrequencyScreenState createState() => _FrequencyScreenState();
}

class _FrequencyScreenState extends State<FrequencyScreen> {
  late HabitData habitData;
  late Map<String, dynamic> frequencyData;

  dynamic _normalizeFrequencyValue(String? option, dynamic value) {
    if (option == null) return null;

    switch (option) {
      case 'repetir':
        return value is int ? value : int.tryParse(value.toString()) ?? 1;

      case 'algumas_vezes_periodo':
        if (value is Map &&
            value['vezes'] != null &&
            value['periodo'] != null) {
          return {
            'vezes': int.tryParse(value['vezes'].toString()) ?? 1,
            'periodo': value['periodo'].toString().toUpperCase(),
          };
        }
        return {'vezes': 1, 'periodo': 'SEMANA'};

      case 'dias_especificos_ano':
        if (value is List) {
          return value
              .map((e) {
                if (e is DateTime) return e;
                if (e is String) return DateTime.tryParse(e);
                return null;
              })
              .where((e) => e != null)
              .toList();
        }
        return [];

      case 'dias_especificos_mes':
      case 'alguns_dias_semana':
        return value is List ? value : [];

      default:
        return value;
    }
  }

  @override
  void initState() {
    super.initState();

    habitData = widget.habitData;

    // Clonar e normalizar o frequencyData
    final raw = habitData.frequencyData;
    final normalizedValue = _normalizeFrequencyValue(
      raw['option'],
      raw['value'],
    );

    frequencyData = {'option': raw['option'], 'value': normalizedValue};
  }

  bool _isFrequencyValid(Map<String, dynamic> data) {
    final option = data['option'];
    final value = data['value'];

    if (option == null) return false;

    switch (option) {
      case 'todos_os_dias':
        return true;
      case 'alguns_dias_semana':
        return value is List && value.isNotEmpty && value.first is String;
      case 'dias_especificos_mes':
        return value is List && value.isNotEmpty && value.first is int;
      case 'dias_especificos_ano':
        return value is List &&
            value.isNotEmpty &&
            (value.first is DateTime ||
                (value.first is String &&
                    DateTime.tryParse(value.first) != null));

      case 'algumas_vezes_periodo':
        return value is Map &&
            value['vezes'] is int &&
            value['periodo'] is String;
      case 'repetir':
        return value is int && value > 0;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FrequencyTheme.backgroundColor,
      appBar: HeaderAppBar(title: 'Definir Frequência'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Appbody(title: 'Frequência que deseja fazer isso?'),
                  SizedBox(height: 24),
                  FrequencyForm(
                    frequencyData: frequencyData,
                    onFrequencyDataChanged: (newData) {
                      setState(() => frequencyData = newData);
                    },
                  ),
                ],
              ),
            ),
          ),
          FrequencyBottomNavigation(
            onPrevious: () {
              Navigator.pushReplacementNamed(
                context,
                '/cadastrar_habito',
                arguments: habitData,
              );
            },
            onNext: () {
              final valid = _isFrequencyValid(frequencyData);
              if (!valid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Por favor, preencha os valores da frequência antes de continuar.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final updatedHabitData = habitData.copyWith(
                frequencyData: frequencyData,
                selectedCategory: habitData.selectedCategory,
              );

              Navigator.pushReplacementNamed(
                context,
                '/prazo',
                arguments: updatedHabitData,
              );
            },
            currentIndex: 1,
          ),
        ],
      ),
    );
  }
}

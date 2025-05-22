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

  @override
  void initState() {
    super.initState();
    habitData = widget.habitData;
    frequencyData = Map<String, dynamic>.from(habitData.frequencyData);
  }

  bool _isFrequencyValid(Map<String, dynamic> data) {
    final option = data['option'];
    final value = data['value'];

    if (option == 'todos_os_dias') return true;

    if (option == 'alguns_dias_semana' && value is List<String> && value.isNotEmpty) {
      return true;
    }

    if (option == 'dias_especificos_mes' && value is List<int> && value.isNotEmpty) {
      return true;
    }

    if (option == 'dias_especificos_ano' && value is List<DateTime> && value.isNotEmpty) {
      return true;
    }

    if (option == 'algumas_vezes_periodo' &&
        value is Map &&
        value['vezes'] is int &&
        value['vezes'] > 0 &&
        value['periodo'] is String &&
        (value['periodo'] as String).isNotEmpty) {
      return true;
    }

    if (option == 'repetir' && value is int && value > 0) {
      return true;
    }

    return false;
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
            onPrevious:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/cadastrar_habito',
                ),
            onNext: () {
              if (!_isFrequencyValid(frequencyData)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, preencha os valores da frequência antes de continuar.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final updatedHabitData = habitData.copyWith(
                frequencyData: frequencyData,
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

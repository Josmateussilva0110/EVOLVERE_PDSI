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

import 'package:flutter/material.dart';
import '../../components/habits_app_bar.dart';
import '../../components/app_header.dart';
import '../themes/frequency_theme.dart';
import '../components/frequency_form.dart';
import '../widgets/navigation.dart';

class FrequencyScreen extends StatefulWidget {
  @override
  _FrequencyScreenState createState() => _FrequencyScreenState();
}

class _FrequencyScreenState extends State<FrequencyScreen> {
  String selectedFrequency = 'todos_os_dias';
  List<String> selectedDaysOfWeek = [];
  List<int> selectedDaysOfMonth = [];
  List<DateTime> selectedYearDays = [];
  int repeatTimes = 1;
  String repeatPeriod = 'SEMANA';

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
                    selectedFrequency: selectedFrequency,
                    onFrequencySelect: (value) {
                      setState(() => selectedFrequency = value);
                    },
                    selectedDaysOfWeek: selectedDaysOfWeek,
                    selectedDaysOfMonth: selectedDaysOfMonth,
                    selectedYearDays: selectedYearDays,
                    repeatTimes: repeatTimes,
                    repeatPeriod: repeatPeriod,
                    onWeekDaysSelected: (days) {
                      setState(() => selectedDaysOfWeek = days);
                    },
                    onMonthDaysSelected: (days) {
                      setState(() => selectedDaysOfMonth = days);
                    },
                    onYearDaysSelected: (dates) {
                      setState(() => selectedYearDays = dates);
                    },
                    onPeriodSelected: (times, period) {
                      setState(() {
                        repeatTimes = times;
                        repeatPeriod = period;
                      });
                    },
                    onRepeatSelected: (times) {
                      setState(() => repeatTimes = times);
                    },
                  ),
                ],
              ),
            ),
          ),
          FrequencyBottomNavigation(
            onPrevious:
                () => Navigator.pushReplacementNamed(context, '/habitos'),
            onNext: () => Navigator.pushReplacementNamed(context, '/prazo'),
          ),
        ],
      ),
    );
  }
}

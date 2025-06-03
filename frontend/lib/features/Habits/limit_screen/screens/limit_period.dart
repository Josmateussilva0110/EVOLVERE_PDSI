import 'package:flutter/material.dart';
import '../../components/habits_app_bar.dart';
import '../../components/app_header.dart';
import '../../components/navigation.dart';
import '../components/limit_period_form.dart';
import '../../model/HabitData.dart';
import '../../frequency_screen/themes/frequency_theme.dart';
import '../../services/habit_service.dart';

class TermScreen extends StatefulWidget {
  final HabitData habitData;

  const TermScreen({Key? key, required this.habitData}) : super(key: key);

  @override
  _TermScreenState createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  late HabitData habitData;

  int priority = 2; //todo: 1 = alta, 2 normal, 3 baixa

  @override
  void initState() {
    super.initState();
    habitData = widget.habitData;
    priority = habitData.priority ?? 2;
    print('Hábito final: $habitData');
  }

  String getPriorityLabel(int value) {
    switch (value) {
      case 1:
        return 'Alta';
      case 2:
        return 'Normal';
      case 3:
        return 'Baixa';
      default:
        return 'Desconhecida';
    }
  }

  void _selectDate({
    required DateTime? initial,
    required Function(DateTime) onDateSelected,
  }) async {
    final now = DateTime.now();
    final initialDate = initial ?? now;

    final firstDate = initialDate.isBefore(now) ? initialDate : now;

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: FrequencyTheme.accentColor,
              onPrimary: FrequencyTheme.textColor,
              surface: FrequencyTheme.cardColor,
              onSurface: FrequencyTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        onDateSelected(date);
      });
    }
  }


  void _selectPriority() {
    final options = {1: 'Alta', 2: 'Normal', 3: 'Baixa'};
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children:
              options.entries.map((entry) {
                return ListTile(
                  title: Text(
                    entry.value,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      priority = entry.key;
                      habitData.priority = entry.key;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  Future<void> _addReminder(BuildContext context) async {
    final now = DateTime.now();
    final startDate = habitData.startDate ?? now;
    final endDate = habitData.endDate ?? DateTime(2100);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: endDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: FrequencyTheme.accentColor,
              onPrimary: FrequencyTheme.textColor,
              surface: FrequencyTheme.cardColor,
              onSurface: FrequencyTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: FrequencyTheme.accentColor,
              onPrimary: FrequencyTheme.textColor,
              surface: FrequencyTheme.cardColor,
              onSurface: FrequencyTheme.textColor,
            ),
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: FrequencyTheme.cardColor,
              hourMinuteTextColor: FrequencyTheme.textColor,
              dialHandColor: FrequencyTheme.accentColor,
              dialBackgroundColor: Color(0xFF1C1F26),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedTime == null) return;

    final reminder = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      habitData.reminders.add(reminder);
    });
  }

  void _removeReminder(DateTime reminder) {
    setState(() {
      habitData.reminders.remove(reminder);
    });
  }

  void _clearEndDate() {
    setState(() {
      habitData.endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: HeaderAppBar(title: 'Definir Prazo'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Appbody(title: 'Quando você quer fazer isso ?'),
                  SizedBox(height: 24),
                  LimitPeriodForm(
                    startDate: habitData.startDate,
                    priority: getPriorityLabel(priority),
                    reminders: habitData.reminders,
                    endDate: habitData.endDate,
                    onSelectedStartDate:
                        () => _selectDate(
                          initial: habitData.startDate,
                          onDateSelected: (date) => habitData.startDate = date,
                        ),
                    onSelectedEndDate:
                        () => _selectDate(
                          initial: habitData.endDate,
                          onDateSelected: (date) => habitData.endDate = date,
                        ),
                    onClearEndDate: _clearEndDate,
                    onSelectedReminders: () => _addReminder(context),
                    onSelectedPriority: _selectPriority,
                    onRemoveReminder: _removeReminder,
                  ),
                ],
              ),
            ),
          ),
          FrequencyBottomNavigation(
            onPrevious:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/cadastrar_frequencia',
                ),
            onNext: () async {
              //print('prioridade (label): ${getPriorityLabel(habitData.priority!)}');
              final errorMessage = await HabitService.createHabit(habitData);
              if (errorMessage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hábito cadastrada com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, '/listar_habitos');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            previousLabel: 'Anterior',
            nextLabel: 'Criar Hábito',
            currentIndex: 2,
          ),
        ],
      ),
    );
  }
}

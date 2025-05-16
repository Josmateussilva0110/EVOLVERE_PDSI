import 'package:flutter/material.dart';
import '../../components/habits_app_bar.dart';
import '../../components/app_header.dart';
import '../../components/navigation.dart';
import '../components/limit_period_form.dart';
import '../../model/HabitData.dart';
import '../../frequency_screen/themes/frequency_theme.dart';

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


  void _selectDate(Function(DateTime) onDateSelected) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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
  final options = {
    1: 'Alta',
    2: 'Normal',
    3: 'Baixa',
  };

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1C1F26),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: options.entries.map((entry) {
          return ListTile(
            title: Text(entry.value, style: TextStyle(color: Colors.white)),
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


  void _selectReminder() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
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
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        habitData.reminderDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
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
                    priority: getPriorityLabel(priority),
                    onSelectedStartDate:
                        () => _selectDate((date) => habitData.startDate = date),
                    onSelectedEndDate:
                        () => _selectDate((date) => habitData.endDate = date),
                    onSelectedReminders: _selectReminder,
                    onSelectedPriority: _selectPriority,
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
            onNext: () {
              print('chegou em limit: ');
              print('Nome do hábito: ${habitData.habitName}');
              print('Descrição: ${habitData.description}');
              print('Categoria: ${habitData.selectedCategory}');
              print('tipo: ${habitData.frequencyData}');
              print('data inicio: ${habitData.startDate}');
              print('data fim: ${habitData.endDate}');
              print('lembrete: ${habitData.reminderDateTime}');
              print('prioridade: ${habitData.priority}');
              //print('prioridade (label): ${getPriorityLabel(habitData.priority!)}');
              Navigator.pushReplacementNamed(context, '/inicio');
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

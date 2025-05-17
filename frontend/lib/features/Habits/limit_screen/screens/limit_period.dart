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
  bool dataAlvoEnabled = false;
  String priority = 'Normal';

  @override
  void initState() {
    super.initState();
    habitData = widget.habitData;

    print('chegou em limit: ');
    print('Nome do hábito: ${habitData.habitName}');
    print('Descrição: ${habitData.description}');
    print('Categoria: ${habitData.selectedCategory}');
    print('tipo: ${habitData.frequencyData}');
  }

  void _selectDate() async {
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
      print('Data de início selecionada: $date');
    }
  }

  void _selectPriority() {
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
              ['Alta', 'Normal', 'Baixa'].map((option) {
                return ListTile(
                  title: Text(option, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      priority = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  void _selecionarLembrete() async {
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

    TimeOfDay? hora = await showTimePicker(
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

    if (hora != null) {
      final dataHora = DateTime(
        date.year,
        date.month,
        date.day,
        hora.hour,
        hora.minute,
      );
      print('Lembrete definido para: $dataHora');
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
                    priority: priority,
                    onSelectedStartDate: _selectDate,
                    onSelectedEndDate: _selectDate,
                    onSelectedReminders: _selecionarLembrete,
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
            onNext: () => Navigator.pushReplacementNamed(context, '/'),
            previousLabel: 'Anterior',
            nextLabel: 'Criar Hábito',
            currentIndex: 2,
          ),
        ],
      ),
    );
  }
}

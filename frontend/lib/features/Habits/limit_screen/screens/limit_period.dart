// lib/features/Habits/limit_screen/screens/limit_period.dart (ou seu caminho correto)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    habitData = widget.habitData;
    // Garante que a prioridade tenha um valor padrão se for nula
    habitData.priority ??= 2; 
  }

  String getPriorityLabel(int value) {
    switch (value) {
      case 1: return 'Alta';
      case 2: return 'Normal';
      case 3: return 'Baixa';
      default: return 'Normal';
    }
  }

  Future<void> _showPeriodoDialog(BuildContext context) async {
    DateTime? tempStartDate = habitData.startDate;
    DateTime? tempEndDate = habitData.endDate;

    final result = await showDialog<Map<String, DateTime?>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<DateTime?> _pickDate(DateTime? initialDate) async {
              return await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
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
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E24),
              title: Text('Definir Período', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.white70),
                    title: Text('Data de Início', style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      tempStartDate != null ? DateFormat('dd/MM/yyyy').format(tempStartDate!) : 'Não definida',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () async {
                      final picked = await _pickDate(tempStartDate);
                      if (picked != null) {
                        setDialogState(() {
                          tempStartDate = picked;
                          if (tempEndDate != null && tempEndDate!.isBefore(tempStartDate!)) {
                            tempEndDate = null;
                          }
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: Colors.white70),
                    title: Text('Data de Fim (Opcional)', style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      tempEndDate != null ? DateFormat('dd/MM/yyyy').format(tempEndDate!) : 'Não definida',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () async {
                      final picked = await _pickDate(tempEndDate ?? tempStartDate);
                      if (picked != null) {
                        setDialogState(() {
                          if (tempStartDate != null && picked.isBefore(tempStartDate!)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A data final não pode ser anterior à data de início.'), backgroundColor: Colors.red));
                          } else {
                            tempEndDate = picked;
                          }
                        });
                      }
                    },
                  ),
                  if (tempEndDate != null)
                    TextButton(
                      child: Text('Remover data final', style: TextStyle(color: Colors.redAccent)),
                      onPressed: () {
                        setDialogState(() {
                          tempEndDate = null;
                        });
                      },
                    )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop({'start': tempStartDate, 'end': tempEndDate});
                  },
                  child: Text('Salvar', style: TextStyle(color: FrequencyTheme.accentColor)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        habitData.startDate = result['start'];
        habitData.endDate = result['end'];
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
          children: options.entries.map((entry) {
            return ListTile(
              title: Text(
                entry.value,
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
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

  @override
  Widget build(BuildContext context) {
    final isEditing = habitData.habitId != null;
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
                    endDate: habitData.endDate,
                    priority: getPriorityLabel(habitData.priority!),
                    reminders: habitData.reminders,
                    onSelectPeriod: () => _showPeriodoDialog(context),
                    onSelectedReminders: () => _addReminder(context),
                    onSelectedPriority: _selectPriority,
                    onRemoveReminder: _removeReminder,
                  ),
                ],
              ),
            ),
          ),
          FrequencyBottomNavigation(
            onPrevious: () => Navigator.pushReplacementNamed(
              context,
              '/cadastrar_frequencia',
              arguments: habitData,
            ),
            onNext: () async {
              final errorMessage = isEditing
                  ? await HabitService.editHabit(habitData)
                  : await HabitService.createHabit(habitData);

              if (mounted) {
                if (errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? 'Hábito editado com sucesso!'
                            : 'Hábito cadastrado com sucesso!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/inicio',
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            previousLabel: 'Anterior',
            nextLabel: isEditing ? 'Editar Hábito' : 'Criar Hábito',
            currentIndex: 2,
          ),
        ],
      ),
    );
  }
}
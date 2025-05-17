// lib/components/limit_period_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/option_button.dart';

class LimitPeriodForm extends StatelessWidget {
  final String priority;
  final VoidCallback onSelectedStartDate;
  final VoidCallback onSelectedEndDate;
  final VoidCallback onSelectedReminders;
  final VoidCallback onSelectedPriority;

  const LimitPeriodForm({
    super.key,
    required this.priority,
    required this.onSelectedStartDate,
    required this.onSelectedEndDate,
    required this.onSelectedReminders,
    required this.onSelectedPriority,
  });

  Color _getPrioridadeColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Baixa':
        return Colors.green;
      case 'Normal':
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionButton(
          icon: Icons.calendar_today,
          title: 'Data de início',
          subtitle: 'Selecione a data de início da tarefa',
          onTap: onSelectedStartDate,
        ),
        OptionButton(
          icon: Icons.calendar_month,
          title: 'Data Fim',
          subtitle: 'Selecione a data de fim da tarefa',
          onTap: onSelectedEndDate,
        ),
        OptionButton(
          icon: Icons.notifications_outlined,
          title: 'Horário e lembretes',
          subtitle: 'Defina horários e lembretes para a tarefa',
          onTap: onSelectedReminders,
        ),
        OptionButton(
          icon: Icons.sort,
          title: 'Prioridade',
          subtitle: 'Selecione o nível de priority',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getPrioridadeColor(priority).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              priority,
              style: GoogleFonts.inter(
                color: _getPrioridadeColor(priority),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: onSelectedPriority,
        ),
      ],
    );
  }
}

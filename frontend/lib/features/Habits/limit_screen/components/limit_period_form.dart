// lib/components/limit_period_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/option_button.dart';
import 'package:intl/intl.dart';

class LimitPeriodForm extends StatelessWidget {
  final String priority;
  final List<DateTime> reminders;
  final VoidCallback onSelectedStartDate;
  final VoidCallback onSelectedEndDate;
  final VoidCallback onSelectedReminders;
  final VoidCallback onSelectedPriority;
  final void Function(DateTime reminder) onRemoveReminder;

  const LimitPeriodForm({
    super.key,
    required this.priority,
    required this.reminders,
    required this.onSelectedStartDate,
    required this.onSelectedEndDate,
    required this.onSelectedReminders,
    required this.onSelectedPriority,
    required this.onRemoveReminder,
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

        if (reminders.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Card(
              color: const Color(0xFF1C1F26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lembretes',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...reminders.map((reminder) {
                      final formatted = DateFormat(
                        'dd/MM/yyyy - HH:mm',
                      ).format(reminder);
                      return Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.notifications,
                                size: 20,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  formatted,
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[300],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                onPressed: () => onRemoveReminder(reminder),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey, height: 8),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
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

// lib/features/Habits/limit_screen/components/limit_period_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/option_button.dart';

class LimitPeriodForm extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String priority;
  final List<DateTime> reminders;
  final VoidCallback onSelectPeriod;
  final VoidCallback onSelectedReminders;
  final VoidCallback onSelectedPriority;
  final void Function(DateTime reminder) onRemoveReminder;

  // Construtor simplificado. A função onClearEndDate não é mais necessária aqui.
  const LimitPeriodForm({
    super.key,
    required this.priority,
    required this.reminders,
    required this.startDate,
    required this.endDate,
    required this.onSelectPeriod,
    required this.onSelectedReminders,
    required this.onSelectedPriority,
    required this.onRemoveReminder,
  });

  String _buildPeriodSubtitle() {
    if (startDate == null) {
      return 'Selecione a data de início da tarefa';
    }
    final formatter = DateFormat('dd/MM/yyyy');
    if (endDate == null || DateUtils.isSameDay(startDate, endDate)) {
      return 'Início: ${formatter.format(startDate!)}';
    }
    return 'De ${formatter.format(startDate!)} até ${formatter.format(endDate!)}';
  }

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
          icon: Icons.date_range_outlined,
          title: 'Período',
          subtitle: _buildPeriodSubtitle(),
          onTap: onSelectPeriod,
        ),
        OptionButton(
          icon: Icons.notifications_outlined,
          title: 'Horário e lembretes',
          subtitle: 'Defina horários e lembretes para a tarefa',
          onTap: onSelectedReminders,
        ),
        if (reminders.isNotEmpty)
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3B4254), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lembretes Definidos',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12.0, // Espaçamento horizontal entre os chips
                    runSpacing: 12.0, // Espaçamento vertical entre as linhas de chips
                    children: reminders.map((reminder) {
                      return Chip(
                        avatar: Icon(Icons.notifications, color: Colors.amber[200], size: 18),
                        label: Text(
                          DateFormat('dd/MM/yy \'às\' HH:mm').format(reminder),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onDeleted: () => onRemoveReminder(reminder),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        deleteIconColor: Colors.white70,
                        backgroundColor: const Color(0xFF2B2D3A),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFF3B4254)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        OptionButton(
          icon: Icons.sort,
          title: 'Prioridade',
          subtitle: 'Selecione o nível de prioridade',
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
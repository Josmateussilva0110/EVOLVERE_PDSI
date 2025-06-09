import 'package:flutter/material.dart';
import '../model/HabitModel.dart';
import 'habit_options_menu.dart';
import '../services/list_habits_service.dart';
import '../services/list_categories_service.dart';
import 'confirm_action_dialog.dart';
import '../screens/progress_record_screen.dart';
import '../../habit_completion/screens/finish_habit_screen.dart';
import '../../Habits/model/HabitData.dart';

class HabitCardWidget extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onHabitArchived;
  final VoidCallback? onHabitDeleted;
  final VoidCallback? onHabitUpdated;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    this.onHabitArchived,
    this.onHabitDeleted,
    this.onHabitUpdated,
  }) : super(key: key);

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return HabitOptionsMenu(
          onViewRecord: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ProgressRecordScreen(
                      habitName: habit.name,
                      category: habit.categoryName ?? 'Categoria',
                      totalMinutes: 6777,
                      dailyAverage: '2h 16min',
                      currentStreak: '1 mês e 3 dias',
                      monthDays: '22 de 31',
                      progressPercent: 0.66,
                      weeklyData: [1, 2, 1, 3, 4, 2, 3],
                    ),
              ),
            );
          },
          onEdit: () async {
            Navigator.pop(context);
            int? categoryId;
              if (habit.categoryName != null) {
                categoryId = await CategoryService.fetchCategoryIdByName(habit.categoryName!);
              }
            await Navigator.pushNamed(
              context,
              '/cadastrar_habito',
              arguments: HabitData(
                habitId: habit.id,
                habitName: habit.name,
                description: habit.description,
                selectedCategory: categoryId,
                frequencyData: {
                  'option': habit.frequency.option,
                  'value': habit.frequency.value,
                },
                startDate: habit.startDate,
                endDate: habit.endDate,
                reminders: habit.reminders ?? [],
                priority: habit.priority,
              ),
            );

            if (onHabitUpdated != null) onHabitUpdated!();
          },
          onArchive: () async {
            final confirm = await showConfirmActionDialog(
              context: context,
              title: 'Arquivar habito',
              message: 'Deseja arquivar?',
              confirmText: 'Arquivar',
              confirmColor: Colors.yellow,
            );

            if (!confirm) return;

            final result = await HabitService.archiveHabit(habit.id);
            if (result) {
              if (onHabitArchived != null) onHabitArchived!();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hábito arquivado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erro ao arquivar hábito!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onDelete: () async {
            final confirm = await showConfirmActionDialog(
              context: context,
              title: 'Excluir habito',
              message: 'Deseja excluir?',
              confirmText: 'Excluir',
              confirmColor: Colors.red,
            );

            if (!confirm) return;

            final result = await HabitService.deleteHabit(habit.id);
            if (result) {
              if (onHabitDeleted != null) onHabitDeleted!();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hábito removido com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erro ao remover hábito!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onComplete: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FinishHabitScreen(habit: habit),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showOptionsMenu(context),
      child: Card(
        color: const Color(0xFF1F222A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getPrioridadeColor(
                        habit.priority,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getPrioridadeTexto(habit.priority),
                      style: TextStyle(
                        color: _getPrioridadeColor(habit.priority),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (habit.description.isNotEmpty)
                Text(
                  habit.description,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPrioridadeColor(int prioridade) {
    switch (prioridade) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPrioridadeTexto(int prioridade) {
    switch (prioridade) {
      case 1:
        return 'Alta';
      case 2:
        return 'Normal';
      case 3:
        return 'Baixa';
      default:
        return 'Não definida';
    }
  }
}

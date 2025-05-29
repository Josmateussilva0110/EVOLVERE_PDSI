import 'package:flutter/material.dart';
import '../model/HabitModel.dart';
import 'habit_options_menu.dart';
import '../services/list_habits_service.dart';
import 'confirm_action_dialog.dart';

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
          onEdit: () async {
            Navigator.pop(context);
            await Navigator.pushNamed(
              context,
              '/editar_habito',
              arguments: habit,
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

  Color _getPrioridadeColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  String _getPrioridadeTexto(int priority) {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Normal';
      default:
        return 'Baixa';
    }
  }
}

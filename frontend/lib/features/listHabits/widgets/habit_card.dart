import 'package:flutter/material.dart';
import '../model/HabitModel.dart';
import '../../register_category/widgets/habit_options_menu.dart';

class HabitCardWidget extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onHabitDeleted;
  final VoidCallback? onHabitUpdated;

  const HabitCardWidget({
    Key? key,
    required this.habit,
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
          onArchive: () {
            Navigator.pop(context);
            _confirmAction(
              context,
              title: 'Arquivar hábito',
              message: 'Deseja arquivar este hábito?',
              onConfirm: () {
                Navigator.pop(context);
                // TODO: lógica para arquivar hábito
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hábito arquivado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          },
          onDelete: () {
            Navigator.pop(context);
            _confirmAction(
              context,
              title: 'Excluir hábito',
              message: 'Deseja excluir este hábito?',
              onConfirm: () {
                if (onHabitDeleted != null) onHabitDeleted!();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hábito excluído com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121217),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('Confirmar', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPrioridadeColor(habit.priority).withOpacity(0.2),
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

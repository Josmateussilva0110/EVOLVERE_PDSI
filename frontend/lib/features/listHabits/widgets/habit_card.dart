import 'package:flutter/material.dart';
import '../model/HabitModel.dart';

class HabitCardWidget extends StatelessWidget {
  final Habit habit;

  const HabitCardWidget({Key? key, required this.habit}) : super(key: key);

  Color _getPrioridadeColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.amber;
      case 3:
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
      case 3:
      default:
        return 'Baixa';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F222A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
    );
  }
}

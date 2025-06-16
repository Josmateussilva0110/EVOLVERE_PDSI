import 'package:flutter/material.dart';
import '../models/HabitModel.dart';
import '../services/home_service.dart';

class TopPrioritiesWidget extends StatefulWidget {
  final int userId;

  const TopPrioritiesWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<TopPrioritiesWidget> createState() => _TopPrioritiesWidgetState();
}

class _TopPrioritiesWidgetState extends State<TopPrioritiesWidget> {
  late Future<List<Habit>> _habitsFuture;

  @override
  void initState() {
    super.initState();
    _habitsFuture = HomeService.fetchTopPriorities(widget.userId);
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Média';
      case 3:
        return 'Baixa';
      default:
        return 'Prioridade $priority';
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getFrequencyOption(Map<String, dynamic> frequency) {

    final option = frequency['option']?.toString().toLowerCase() ?? '';

    switch (option) {
      case 'diário':
        return 'Diário';
      case 'semanal':
        return 'Semanal';
      case 'mensal':
        return 'Mensal';
      default:
        return option
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Habit>>(
      future: _habitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar hábitos: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum hábito encontrado',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final sortedHabits = List<Habit>.from(snapshot.data!)
          ..sort((a, b) => a.priority.compareTo(b.priority));

        return Column(
          children:
              sortedHabits.map((habit) {
                final priorityColor = _getPriorityColor(habit.priority);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    color: const Color(0xFF1F222A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: priorityColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  habit.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      size: 14,
                                      color: priorityColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getPriorityText(habit.priority),
                                      style: TextStyle(
                                        color: priorityColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.blue.withOpacity(0.7),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getFrequencyOption(habit.frequency),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}

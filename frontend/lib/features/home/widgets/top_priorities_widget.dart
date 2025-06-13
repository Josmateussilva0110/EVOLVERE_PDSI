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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: FutureBuilder<List<Habit>>(
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
                'Nenhum hábito prioritário encontrado',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final habit = snapshot.data![index];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 12.0),
                child: Card(
                  color: const Color(0xFF1F222A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Prioridade ${habit.priority}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (habit.description.isNotEmpty)
                          Text(
                            habit.description,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8),
                        if (habit.categoryName.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              habit.categoryName,
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Frequência: ${habit.frequency['option'] ?? 'Não definida'}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/list_habits_service.dart';
import '../models/HabitModel.dart';

class ArchivedHabitsModal extends StatefulWidget {
  final VoidCallback? onHabitRestored;
  const ArchivedHabitsModal({super.key, this.onHabitRestored});

  @override
  State<ArchivedHabitsModal> createState() => _ArchivedHabitsModalState();
}

class _ArchivedHabitsModalState extends State<ArchivedHabitsModal> {
  bool isLoading = true;
  List<Habit> archivedHabits = [];

  @override
  void initState() {
    super.initState();
    _loadArchived();
  }

  Future<void> _loadArchived() async {
    archivedHabits = await HabitService.fetchHabitsArchived();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF121217),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hábitos Arquivados',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (archivedHabits.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Nenhum hábito arquivado.',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: archivedHabits.length,
                  itemBuilder: (context, index) {
                    final habit = archivedHabits[index];
                    return ListTile(
                      title: Text(
                        habit.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(Icons.restore, color: Colors.green),
                      onTap: () async {
                        final success = await HabitService.activeHabit(
                          habit.id,
                        );
                        if (success) {
                          setState(() {
                            archivedHabits.removeAt(index);
                          });
                          if (widget.onHabitRestored != null) {
                            widget.onHabitRestored!();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Hábito restaurado com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao restaurar hábito.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

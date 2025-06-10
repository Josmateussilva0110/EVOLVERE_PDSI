import 'package:flutter/material.dart';
import '../services/list_habits_service.dart';
import '../models/HabitModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchivedHabitsModal extends StatefulWidget {
  final VoidCallback? onHabitRestored;
  const ArchivedHabitsModal({super.key, this.onHabitRestored});

  @override
  State<ArchivedHabitsModal> createState() => _ArchivedHabitsModalState();
}

class _ArchivedHabitsModalState extends State<ArchivedHabitsModal> {
  bool isLoading = true;
  List<Habit> _archivedHabits = [];
  int? userId;

  Future<int?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserId');
  }

  Future<void> _loadArchived() async {
    if (userId == null) return;
    final allArchivedHabits = await HabitService.fetchHabitsArchived(userId!);
    if (mounted) {
      setState(() {
        _archivedHabits = allArchivedHabits;
        isLoading = false;
      });
    }
  }

  Future<void> _initData() async {
    final id = await _loadUserId();
    if (id != null) {
      setState(() {
        userId = id;
      });
      _loadArchived(); 
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
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
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_archivedHabits.isEmpty)
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
                  itemCount: _archivedHabits.length,
                  itemBuilder: (context, index) {
                    final habit = _archivedHabits[index];
                    return ListTile(
                      title: Text(
                        habit.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(Icons.restore, color: Colors.green),
                      onTap: () async {
                        final success = await HabitService.activeHabit(habit.id);
                        if (success) {
                          setState(() {
                            _archivedHabits.removeAt(index);
                          });
                          widget.onHabitRestored?.call();
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

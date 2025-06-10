import 'package:flutter/material.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar.dart';
import '../services/list_habits_service.dart';
import '../models/HabitModel.dart';
import '../widgets/habit_card.dart';
import '../widgets/archived_habits.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HabitsListPage extends StatefulWidget {
  const HabitsListPage({Key? key}) : super(key: key);

  @override
  State<HabitsListPage> createState() => _HabitsListPageState();
}

class _HabitsListPageState extends State<HabitsListPage> {
  Future<List<Habit>> _habitsFuture = Future.value([]);
  String? selectedCategory;
  int? userId;

  Future<int?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserId');
  }


  Future<void> _loadHabits() async {
    if (userId == null) return;

    final allHabits = await HabitService.fetchHabits(userId!);
    setState(() {
      if (selectedCategory != null) {
        _habitsFuture = Future.value(
          allHabits.where((h) => h.categoryName == selectedCategory).toList(),
        );
      } else {
        _habitsFuture = Future.value(allHabits);
      }
    });
  }


  Future<void> _initData() async {
    final id = await _loadUserId();
    if (id != null) {
      setState(() {
        userId = id;
        _habitsFuture = HabitService.fetchHabits(id); 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }




  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF181A20),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181A20),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/inicio');
            },
          ),
          title: const Text('Hábitos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.archive),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder:
                      (_) => ArchivedHabitsModal(
                        onHabitRestored: () {
                          _loadHabits();
                        },
                      ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const FilterChipsWidget(),
              const SizedBox(height: 12),
              SearchBarWidget(
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                  _loadHabits();
                },
              ),
              if (selectedCategory != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                      });
                      _loadHabits();
                    },
                    child: const Text(
                      'Limpar Filtro',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Habit>>(
                  future: _habitsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum hábito cadastrado.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    } else {
                      final habits = snapshot.data!;
                      return ListView.builder(
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final habit = habits[index];
                          return HabitCardWidget(
                            habit: habit,
                            onHabitArchived: () {
                              setState(() {
                                _habitsFuture = HabitService.fetchHabits(userId!);
                              });
                            },
                            onHabitDeleted: () {
                              setState(() {
                                _habitsFuture = HabitService.fetchHabits(userId!);
                              });
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/cadastrar_habito');
            },
            icon: const Icon(Icons.add),
            label: const Text('Novo Hábito'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

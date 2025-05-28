import 'package:flutter/material.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_bar.dart';
import '../services/list_habits_service.dart';
import '../model/HabitModel.dart';
import '../widgets/habit_card.dart';
import '../widgets/archived_habits.dart';

class HabitsListPage extends StatefulWidget {
  const HabitsListPage({Key? key}) : super(key: key);

  @override
  State<HabitsListPage> createState() => _HabitsListPageState();
}

class _HabitsListPageState extends State<HabitsListPage> {
  late Future<List<Habit>> _habitsFuture;
  String? _selectedCategory;

  Future<void> _loadHabits() async {
    final allHabits = await HabitService.fetchHabits();
    setState(() {
      if (_selectedCategory != null) {
        _habitsFuture = Future.value(
          allHabits.where((h) => h.categoryName == _selectedCategory).toList(),
        );
      } else {
        _habitsFuture = Future.value(allHabits);
      }
    });
  }

  void _showArchivedHabits() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ArchivedHabitsModal(),
    );
  }


  @override
  void initState() {
    super.initState();
    _habitsFuture = HabitService.fetchHabits();
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
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: _showArchivedHabits,
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
                    _selectedCategory = category;
                  });
                  _loadHabits(); // recarrega a lista com filtro aplicado
                },
              ),

              if (_selectedCategory != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                      _loadHabits(); // recarrega todos os hábitos
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
                            onHabitDeleted: () {
                              setState(() {
                                _habitsFuture = HabitService.fetchHabits();
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

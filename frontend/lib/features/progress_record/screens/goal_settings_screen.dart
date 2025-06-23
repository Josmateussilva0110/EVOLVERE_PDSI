import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Goal.dart';
import '../screens/add_goal_screen.dart';
import '../widgets/goal_card.dart';

class GoalSettingsScreen extends StatelessWidget {
  final int habitId;

  final List<Goal> goals = [
    Goal(
      title: 'Estudar 30hrs este mês',
      type: 'Monitorada pelo sistema',
      progress: 12,
      total: 30,
      isProgressBar: true,
    ),
    Goal(
      title: 'Ler tópico x 10 vezes',
      type: 'Acumulativa',
      progress: 6,
      total: 10,
      isProgressBar: false,
    ),
    Goal(
      title: 'Entregar o resumo até sexta',
      type: 'Manual',
      progress: null,
      total: null,
      isProgressBar: false,
    ),
    Goal(
      title: 'Estudar o tópico x',
      type: 'Manual',
      progress: null,
      total: null,
      isProgressBar: false,
    ),
  ];

  GoalSettingsScreen(this.habitId, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF10182B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Visualizar/editar metas',
            style: GoogleFonts.inter(
              color: Colors.blue[200],
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: goals.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index < goals.length) {
                      final goal = goals[index];
                      return GoalCard(goal: goal, habitId: habitId);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AddGoalScreen(habitId: habitId),
                                ),
                              );
                            },
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            highlightElevation: 0,
                            shape: const CircleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

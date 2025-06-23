import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Goal.dart';
import '../screens/add_goal_screen.dart';
import '../service/progress_record_service.dart';
import '../widgets/goal_card.dart';

class GoalSettingsScreen extends StatefulWidget {
  final int habitId;

  const GoalSettingsScreen(this.habitId, {super.key});

  @override
  State<GoalSettingsScreen> createState() => _GoalSettingsScreenState();
}

class _GoalSettingsScreenState extends State<GoalSettingsScreen> {
  List<Goal> goals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    final progressList = await ProgressRecordService.fetchProgressHabit(
      widget.habitId,
    );

    setState(() {
      goals =
          progressList.map((e) {
            return Goal(
              title: e.name ?? 'Meta sem nome',
              type: e.type_description ?? 'Monitorado',
              progress: e.parameter ?? 0,
              total: _defineTotal(e.type),
              isProgressBar: e.type == 0, // apenas 'automático' mostra barra
            );
          }).toList();
      isLoading = false;
    });
  }

  int _defineTotal(int? type) {
    if (type == 2) return 10; // acumulativa
    if (type == 0) return 30; // automático (ex.: horas no mês)
    return 1; // manual não tem total
  }


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
        body:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: goals.length + 1,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            if (index < goals.length) {
                              final goal = goals[index];
                              return GoalCard(
                                goal: goal,
                                habitId: widget.habitId,
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Center(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => AddGoalScreen(
                                                habitId: widget.habitId,
                                              ),
                                        ),
                                      );
                                    },
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    highlightElevation: 0,
                                    shape: const CircleBorder(
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
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

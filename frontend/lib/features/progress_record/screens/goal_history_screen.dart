import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Goal.dart';
import '../service/progress_record_service.dart';
import '../widgets/goal_progress_info.dart';

class GoalHistoryScreen extends StatefulWidget {
  final int habitId;
  const GoalHistoryScreen({Key? key, required this.habitId}) : super(key: key);

  @override
  State<GoalHistoryScreen> createState() => _GoalHistoryScreenState();
}

class _GoalHistoryScreenState extends State<GoalHistoryScreen> {
  List<Goal> goals = [];
  bool isLoading = true;
  String search = '';

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
          progressList
              .map(
                (e) => Goal(
                  id: e.id,
                  title: e.name ?? 'Meta sem nome',
                  type: e.type_description ?? 'Monitorado',
                  progress: e.parameter ?? 0,
                  total: _defineTotal(e.type),
                  isProgressBar: e.type == 0,
                  status: _getGoalStatus(e.status),
                ),
              )
              .toList();
      isLoading = false;
    });
  }

  String _getGoalStatus(int? status) {
    switch (status) {
      case 0:
        return 'Cancelado';
      case 2:
        return 'Concluído';
      case 1:
      default:
        return 'Em andamento';
    }
  }

  int _defineTotal(int? type) {
    if (type == 2) return 10; // acumulativa
    if (type == 0) return 30; // automático (ex.: horas no mês)
    return 1; // manual não tem total
  }

  Widget _buildStatusPanel(List<Goal> goals) {
    int emAndamento = goals.where((g) => g.status == 'Em andamento').length;
    int concluidos = goals.where((g) => g.status == 'Concluído').length;
    int cancelados = goals.where((g) => g.status == 'Cancelado').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCountCard(
            'Em andamento',
            emAndamento,
            Colors.blueAccent,
            Icons.timelapse,
          ),
          _buildCountCard(
            'Concluídos',
            concluidos,
            Colors.green,
            Icons.check_circle,
          ),
          _buildCountCard(
            'Cancelados',
            cancelados,
            Colors.redAccent,
            Icons.cancel,
          ),
        ],
      ),
    );
  }

  Widget _buildCountCard(String label, int count, Color color, IconData icon) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: GoogleFonts.inter(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    String label;
    switch (status.toLowerCase()) {
      case 'concluído':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Concluído';
        break;
      case 'cancelado':
        color = Colors.redAccent;
        icon = Icons.cancel;
        label = 'Cancelado';
        break;
      default:
        color = Colors.blueAccent;
        icon = Icons.timelapse;
        label = 'Em andamento';
    }
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color color;
    IconData icon;
    String label;
    switch (type.toLowerCase()) {
      case 'automático':
        color = Colors.blueAccent;
        icon = Icons.settings;
        label = 'Automática';
        break;
      case 'manual':
        color = Colors.orangeAccent;
        icon = Icons.edit;
        label = 'Manual';
        break;
      case 'acumulativa':
        color = Colors.purpleAccent;
        icon = Icons.arrow_upward;
        label = 'Acumulativa';
        break;
      default:
        color = Colors.grey;
        icon = Icons.flag;
        label = type;
    }
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGoals =
        goals.where((g) {
          final query = search.toLowerCase();
          return g.title.toLowerCase().contains(query) ||
              g.type.toLowerCase().contains(query) ||
              (g.status?.toLowerCase().contains(query) ?? false);
        }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF10182B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Histórico de Metas',
            style: GoogleFonts.inter(
              color: Colors.blue[200],
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            _buildStatusPanel(filteredGoals),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar meta, status ou tipo...',
                  prefixIcon: Icon(Icons.search, color: Colors.blue[200]),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: GoogleFonts.inter(color: Colors.white54),
                ),
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                      : filteredGoals.isEmpty
                      ? Center(
                        child: Text(
                          'Nenhuma meta encontrada para este hábito.',
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredGoals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final goal = filteredGoals[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF232B3E),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    _buildTypeBadge(goal.type),
                                    _buildStatusBadge(
                                      goal.status ?? 'Em andamento',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  goal.title,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GoalProgressInfo(goal: goal),
                              ],
                            ),
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

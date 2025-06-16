import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/add_goal_screen.dart';

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
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 0,
                  ),
                  itemCount: goals.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index < goals.length) {
                      final goal = goals[index];
                      return _GoalCard(goal: goal, habitId: habitId,);
                    } else {
                      // Botão de adicionar nova meta
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddGoalScreen(habitId: habitId),
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

class _GoalCard extends StatefulWidget {
  final Goal goal;
  final int habitId;

  const _GoalCard({
    required this.goal,
    required this.habitId,
  });

  @override
  State<_GoalCard> createState() => _GoalCardState();
}


class _GoalCardState extends State<_GoalCard> {
  bool _isPressed = false;

  void _showActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF232B3E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  _ActionIcon(
                    icon: Icons.check,
                    label: 'Concluir',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _ActionIcon(
                    icon: Icons.edit,
                    label: 'Editar',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddGoalScreen(
                            habitId: widget.habitId,
                            initialName: widget.goal.title,
                            initialType: _goalTypeToIndex(widget.goal.type),
                            initialParameter: widget.goal.progress ?? 10,
                            initialInterval: 0,
                            isEditing: true,
                          ),
                        ),
                      );
                    },
                  ),
                  _ActionIcon(
                    icon: Icons.remove_circle_outline,
                    label: 'Remover',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _ActionIcon(
                    icon: Icons.delete,
                    label: 'Excluir',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _showActionsBottomSheet,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFF2B3756) : const Color(0xFF232B3E),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            if (_isPressed)
              BoxShadow(
                color: Colors.blue.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.goal.title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white24, size: 22),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.goal.isProgressBar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.goal.type,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value:
                        (widget.goal.progress ?? 0) / (widget.goal.total ?? 1),
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.goal.progress} h / ${widget.goal.total} h',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            else if (widget.goal.progress != null && widget.goal.total != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.goal.type,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${widget.goal.progress}/${widget.goal.total}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              Text(
                widget.goal.type,
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}

int _goalTypeToIndex(String type) {
  switch (type.toLowerCase()) {
    case 'automático':
    case 'automatico':
      return 0;
    case 'manual':
      return 1;
    case 'acumulativa':
      return 2;
    default:
      return 0;
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220, minWidth: 120),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class Goal {
  final String title;
  final String type;
  final int? progress;
  final int? total;
  final bool isProgressBar;
  Goal({
    required this.title,
    required this.type,
    this.progress,
    this.total,
    this.isProgressBar = false,
  });
}

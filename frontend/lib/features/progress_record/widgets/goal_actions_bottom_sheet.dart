import 'package:flutter/material.dart';
import '../screens/add_goal_screen.dart';
import '../widgets/action_icon.dart';
import '../model/Goal.dart';

class GoalActionsBottomSheet extends StatelessWidget {
  final Goal goal;
  final int habitId;
  final int Function(String) goalTypeToIndex;

  const GoalActionsBottomSheet({
    super.key,
    required this.goal,
    required this.habitId,
    required this.goalTypeToIndex,
  });

  @override
  Widget build(BuildContext context) {
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
              ActionIcon(
                icon: Icons.check,
                label: 'Concluir',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ActionIcon(
                icon: Icons.edit,
                label: 'Editar',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddGoalScreen(
                        habitId: habitId,
                        initialName: goal.title,
                        initialType: goalTypeToIndex(goal.type),
                        initialParameter: goal.progress ?? 10,
                        initialInterval: 0,
                        isEditing: true,
                      ),
                    ),
                  );
                },
              ),
              ActionIcon(
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
  }
}

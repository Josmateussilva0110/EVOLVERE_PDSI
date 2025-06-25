import 'package:flutter/material.dart';
import '../screens/add_goal_screen.dart';
import '../widgets/action_icon.dart';
import '../model/Goal.dart';
import '../service/progress_record_service.dart';

class GoalActionsBottomSheet extends StatelessWidget {
  final Goal goal;
  final int habitId;
  final int Function(String) goalTypeToIndex;
  final VoidCallback onDeleteSuccess;
  final VoidCallback onCompleted;
  final VoidCallback onCancel;

  const GoalActionsBottomSheet({
    super.key,
    required this.goal,
    required this.habitId,
    required this.goalTypeToIndex,
    required this.onDeleteSuccess,
    required this.onCompleted,
    required this.onCancel,
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
                onTap: () async {
                  Navigator.pop(context);

                  final success = await ProgressRecordService.completeProgress(
                    goal.id!,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Progresso concluído com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    onCompleted();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao completar progresso'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
                      builder:
                          (_) => AddGoalScreen(
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
                onTap: () async {
                  Navigator.pop(context);

                  final success = await ProgressRecordService.deleteProgress(
                    goal.id!,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Progresso excluído com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    onDeleteSuccess();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao excluir progresso'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              ActionIcon(
                icon: Icons.close,
                label: 'Cancelar',
                onTap: () async {
                  Navigator.pop(context);

                  final success = await ProgressRecordService.cancelProgress(
                    goal.id!,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Progresso cancelado'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    onCancel();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao cancelar progresso'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

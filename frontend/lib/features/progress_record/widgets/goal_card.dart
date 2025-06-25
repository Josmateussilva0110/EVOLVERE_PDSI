import 'package:flutter/material.dart';
import '../model/Goal.dart';
import 'goal_actions_bottom_sheet.dart';
import 'goal_header.dart';
import 'goal_progress_info.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final int habitId;
  final VoidCallback onDeleteSuccess;
  final VoidCallback onCompletedSuccess;

  const GoalCard({
    super.key,
    required this.goal,
    required this.habitId,
    required this.onDeleteSuccess,
    required this.onCompletedSuccess,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool _isPressed = false;

  int _goalTypeToIndex(String type) {
    switch (type.toLowerCase()) {
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

  void _showActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF232B3E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => GoalActionsBottomSheet(
            goal: widget.goal,
            habitId: widget.habitId,
            goalTypeToIndex: _goalTypeToIndex,
            onDeleteSuccess: widget.onDeleteSuccess,
            onCompleted: widget.onCompletedSuccess,
          ),
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
            GoalHeader(title: widget.goal.title),
            const SizedBox(height: 8),
            GoalProgressInfo(goal: widget.goal),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Goal.dart';
import '../screens/add_goal_screen.dart';
import 'action_icon.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final int habitId;

  const GoalCard({super.key, required this.goal, required this.habitId});

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
                          builder:
                              (_) => AddGoalScreen(
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
                  ActionIcon(
                    icon: Icons.remove_circle_outline,
                    label: 'Remover',
                    onTap: () {
                      Navigator.pop(context);
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
            _buildHeader(),
            const SizedBox(height: 8),
            _buildProgressOrInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
        const Icon(Icons.more_vert, color: Colors.white24, size: 22),
      ],
    );
  }

  Widget _buildProgressOrInfo() {
    if (widget.goal.isProgressBar) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.goal.type,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: (widget.goal.progress ?? 0) / (widget.goal.total ?? 1),
            minHeight: 8,
            backgroundColor: Colors.white12,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.goal.progress} h / ${widget.goal.total} h',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
        ],
      );
    } else if (widget.goal.progress != null && widget.goal.total != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.goal.type,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
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
      );
    } else {
      return Text(
        widget.goal.type,
        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
      );
    }
  }
}

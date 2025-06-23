import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/Goal.dart';

class GoalProgressInfo extends StatelessWidget {
  final Goal goal;

  const GoalProgressInfo({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final type = goal.type.toLowerCase();

    if (type == 'automático') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.type,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: (goal.progress ?? 0) / (goal.total ?? 1),
            minHeight: 8,
            backgroundColor: Colors.white12,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 6),
          Text(
            '${goal.progress} h / ${goal.total} h',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
        ],
      );
    } else if (type == 'acumulativa') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            goal.type,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
          ),
          Text(
            '${goal.progress ?? 0}',
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
        goal.type,
        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
      );
    }
  }
}

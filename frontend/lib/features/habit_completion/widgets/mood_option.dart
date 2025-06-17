import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodOption extends StatelessWidget {
  final String label;
  final IconData iconData;
  final int index;
  final int selectedMood;
  final void Function(int) onTap;

  const MoodOption({
    super.key,
    required this.label,
    required this.iconData,
    required this.index,
    required this.selectedMood,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedMood == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: isSelected ? 3 : 0,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Icon(
              iconData,
              color: isSelected ? Colors.blue : Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.blue : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

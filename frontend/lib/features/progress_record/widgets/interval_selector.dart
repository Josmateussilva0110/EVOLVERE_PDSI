import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntervalSelector extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const IntervalSelector({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color:
              selected
                  ? Colors.blue.withOpacity(0.18)
                  : const Color(0xFF232B3E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.blue : Colors.white12,
            width: 2,
          ),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? Colors.blue : Colors.white54,
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
      ),
    );
  }
}
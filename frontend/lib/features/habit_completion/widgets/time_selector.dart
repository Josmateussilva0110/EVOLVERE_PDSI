import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeSelector extends StatelessWidget {
  final int hours;
  final int minutes;
  final VoidCallback onTap;

  const TimeSelector({
    super.key,
    required this.hours,
    required this.minutes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF232B3E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}min',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.access_time, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

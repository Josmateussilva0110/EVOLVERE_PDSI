import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeCard extends StatelessWidget {
  final int hours;
  final int minutes;
  final VoidCallback onTap;

  const TimeCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.access_time,
                color: Colors.blue,
                size: 32,
              ),
            ),
            const SizedBox(width: 18),
            Text(
              '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}min',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

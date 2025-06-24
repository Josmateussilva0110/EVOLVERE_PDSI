import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionIcon({
    super.key,
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

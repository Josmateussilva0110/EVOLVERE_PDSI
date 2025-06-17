import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeSelector extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double iconSize; // tamanho do ícone dinâmico
  final double fontSize; // tamanho da fonte dinâmico

  const TypeSelector({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.selected,
    required this.onTap,
    this.iconSize = 30.0,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? iconColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? iconColor : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


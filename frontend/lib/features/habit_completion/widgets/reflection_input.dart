import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReflectionInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ReflectionInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      maxLength: 250,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Hoje foi desafiador, mas consegui manter o foco...',
        hintStyle: GoogleFonts.inter(
          color: Colors.white54,
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xFF232B3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        counterText: '${controller.text.length}/250',
        counterStyle: GoogleFonts.inter(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

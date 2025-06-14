import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final Function(String) onChanged;

  const NameField({
    super.key,
    required this.controller,
    required this.isValid,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: MediaQuery.of(context).size.width * 0.045,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Nome',
        labelStyle: GoogleFonts.inter(
          color: Colors.white70,
          fontSize: MediaQuery.of(context).size.width * 0.035,
        ),
        hintText: 'Leitura, revisar...',
        hintStyle: GoogleFonts.inter(
          color: Colors.white24,
          fontSize: MediaQuery.of(context).size.width * 0.035,
        ),
        filled: true,
        fillColor: const Color(0xFF232B3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        suffixIcon: isValid
            ? const Icon(Icons.check_circle, color: Colors.greenAccent, size: 22)
            : const Icon(Icons.error_outline, color: Colors.redAccent, size: 22),
      ),
      onChanged: onChanged,
    );
  }
}

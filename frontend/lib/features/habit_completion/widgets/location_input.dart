import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationInput extends StatelessWidget {
  final TextEditingController controller;

  const LocationInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Casa, Biblioteca, Academia...',
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
      ),
    );
  }
}

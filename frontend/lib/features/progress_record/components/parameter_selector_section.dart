import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParameterSelectorSection extends StatelessWidget {
  final int selectedType;
  final int parameterValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onInfoTap;

  const ParameterSelectorSection({
    super.key,
    required this.selectedType,
    required this.parameterValue,
    required this.onIncrement,
    required this.onDecrement,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width * 0.035;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Parâmetro',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onInfoTap,
              child: const Icon(Icons.info_outline, color: Colors.white38, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (selectedType != 1)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF232B3E),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      splashRadius: 20,
                      onPressed: onDecrement,
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '$parameterValue',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      splashRadius: 20,
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              )
            else
              Text(
                'Sem parâmetro',
                style: GoogleFonts.inter(
                  color: Colors.white38,
                  fontSize: fontSize,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

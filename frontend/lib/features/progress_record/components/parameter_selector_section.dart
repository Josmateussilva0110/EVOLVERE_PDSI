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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    final double labelFontSize = isLandscape ? screenWidth * 0.035 : screenWidth * 0.04;
    final double valueFontSize = isLandscape ? screenWidth * 0.04 : screenWidth * 0.05;
    final double iconSize = isLandscape ? 18 : 22;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Parâmetro',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onInfoTap,
              child: Icon(
                Icons.info_outline,
                color: Colors.white38,
                size: iconSize,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            if (selectedType != 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF232B3E),
                  borderRadius: BorderRadius.circular(12),
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
                    // Botão -
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      splashRadius: 22,
                      onPressed: onDecrement,
                    ),

                    IntrinsicWidth(
                      child: Center(
                        child: Text(
                          '$parameterValue',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: valueFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      splashRadius: 22,
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
                  fontSize: labelFontSize,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
